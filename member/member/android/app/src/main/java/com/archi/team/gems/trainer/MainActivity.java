package com.archi.team.gems.trainer;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.util.Log;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.os.Message;
import android.os.Handler;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.UUID;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {
    // Flutter methodchannel, event
    private static final String TAG = "gems_user_bt";
    private MethodChannel methodChannel;
    private EventSink selectedDeviceSink;
    private EventSink receiveMsgSink;
    private EventSink receiveStrengthSink;
    private EventSink receiveSpeedSink;
    private EventSink receiveCountSink;
    private EventSink receiveTotalTimeSink;
    private static final String STREAM_SELECTED_DEVICE = "com.archi.team.gems.user/eventSelectedDevice";
    private static final String STREAM_RECEIVE_MSG = "com.archi.team.gems.user/eventReciveMsg";
    private static final String STREAM_RECEIVE_STRENGTH = "com.archi.team.gems.user/eventReciveStrength";
    private static final String STREAM_RECEIVE_SPEED = "com.archi.team.gems.user/eventReciveSpeed";
    private static final String STREAM_RECEIVE_COUNT = "com.archi.team.gems.user/eventReciveCount";
    private static final String STREAM_RECEIVE_TOTAL_TIME = "com.archi.team.gems.user/eventReciveTotalTime";


    // General Bluetooth
    private BluetoothAdapter bluetoothAdapter;
    private static final int REQUEST_ENABLE_BT = 1;

    //Receiver to get the selected device information
    private BroadcastReceiver devicePickerReceiver = null;
    private String selectedDeviceAddress = null;
    private String selectedDeviceName = null;

    private ConnectThread mConnectThread;
    private ConnectedThread mConnectedThread;
    private int mSocketState;
    public static final UUID SPP_SECURE_UUID = UUID.fromString("aa87c0d0-afac-11de-8a39-0800200c9a66");

    // Constants that indicate the current connection state
    public static final int STATE_NONE = 0;       // we're doing nothing
    public static final int STATE_LISTEN = 1;     // now listening for incoming connections
    public static final int STATE_CONNECTING = 2; // now initiating an outgoing connection
    public static final int STATE_CONNECTED = 3;  // now connected to a remote device

    private int workoutMode = 0;
    private int trainingCount = 0;
    private int trainingTotalTime = 0;
    private int workoutStrength = 0;
    private int workoutSpeed = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "### onCreate ###");

        // check permission
        if(checkSelfPermission(Manifest.permission.BLUETOOTH)== PackageManager.PERMISSION_DENIED){
            Log.d("permission check", "BLUETOOTH permission no granted");
            requestPermissions(new String[]{Manifest.permission.BLUETOOTH},REQUEST_ENABLE_BT);
        }
        if(checkSelfPermission(Manifest.permission.BLUETOOTH_ADMIN)== PackageManager.PERMISSION_DENIED){
            Log.d("permission check", "BLUETOOTH_ADMIN permission no granted");
            requestPermissions(new String[]{Manifest.permission.BLUETOOTH_ADMIN},REQUEST_ENABLE_BT);
        }
        if(checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN)== PackageManager.PERMISSION_DENIED){
            Log.d("permission check", "BLUETOOTH_SCAN permission no granted");
            if (Build.VERSION.SDK_INT >= 31) {
                requestPermissions(new String[]{Manifest.permission.BLUETOOTH_SCAN},REQUEST_ENABLE_BT);
            }
        }
        if(checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT)== PackageManager.PERMISSION_DENIED){
            Log.d("permission check", "BLUETOOTH_CONNECT permission no granted");
            if (Build.VERSION.SDK_INT >= 31) {
                requestPermissions(new String[]{Manifest.permission.BLUETOOTH_CONNECT},REQUEST_ENABLE_BT);
            }
        }

        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (bluetoothAdapter == null) {
            Log.e(TAG, "Unable to get BluetoothAdapter");
            return;
        }

        //bluetooth enable
        if (!bluetoothAdapter.isEnabled()) {
            Log.d(TAG, "Enable BT");
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }

        // device picker
        //Receiver to get the selected device information
        devicePickerReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                //context.unregisterReceiver(this);
                Log.d(TAG, "### onReceived devicePickerReceiver ###");
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                selectedDeviceName = device.getName();
                selectedDeviceAddress = device.getAddress();
                Log.d(TAG, "### Device: " + selectedDeviceName + ", " + selectedDeviceAddress);

                showStatusMsg("Disconnected");
                connect(device, true);
            }
        };
    }

    private void initClient() {
    }

    private void deinitClient() {
        if (mConnectThread != null) {
            mConnectThread.cancel();
            mConnectThread = null;
        }

        if (mConnectedThread != null) {
            mConnectedThread.cancel();
            mConnectedThread = null;
        }
    }

    public synchronized void connect(BluetoothDevice device, boolean secure) {
        Log.d(TAG, "connect to: " + device);
        showStatusMsg("Connecting...");

        // Cancel any thread attempting to make a connection
        if (mSocketState == STATE_CONNECTING) {
            if (mConnectThread != null) {
                mConnectThread.cancel();
                mConnectThread = null;
            }
        }

        // Cancel any thread currently running a connection
        if (mConnectedThread != null) {
            mConnectedThread.cancel();
            mConnectedThread = null;
        }

        // Start the thread to connect with the given device
        mConnectThread = new ConnectThread(device, secure);
        mConnectThread.start();
    }

    public synchronized void connected(BluetoothSocket socket, BluetoothDevice
            device, final String socketType) {
        Log.d(TAG, "connected, Socket Type:" + socketType);
        showStatusMsg("Connected");

        // Cancel the thread that completed the connection
        if (mConnectThread != null) {
            mConnectThread.cancel();
            mConnectThread = null;
        }

        // Cancel any thread currently running a connection
        if (mConnectedThread != null) {
            mConnectedThread.cancel();
            mConnectedThread = null;
        }

        // Start the thread to manage the connection and perform transmissions
        mConnectedThread = new ConnectedThread(socket, socketType);
        mConnectedThread.start();
    }

    private class ConnectThread extends Thread {
        private final BluetoothSocket mmSocket;
        private final BluetoothDevice mmDevice;
        private final String mSocketType;

        public ConnectThread(BluetoothDevice device, boolean secure) {
            mmDevice = device;
            BluetoothSocket bluetoothSocket = null;
            mSocketType = secure ? "Secure" : "Insecure";

            // Get a BluetoothSocket for a connection with the
            // given BluetoothDevice
            try {
                if (secure) {
                    bluetoothSocket = device.createRfcommSocketToServiceRecord(
                            SPP_SECURE_UUID);
                }
            } catch (IOException e) {
                Log.e(TAG, "Socket Type: " + mSocketType + "create() failed", e);
            }
            mmSocket = bluetoothSocket;
            mSocketState = STATE_CONNECTING;
        }

        public void run() {
            Log.i(TAG, "BEGIN mConnectThread SocketType:" + mSocketType);
            setName("ConnectThread" + mSocketType);

            // Make a connection to the BluetoothSocket
            try {
                // This is a blocking call and will only return on a
                // successful connection or an exception
                mmSocket.connect();
            } catch (IOException e) {
                // Close the socket
                try {
                    mmSocket.close();
                } catch (IOException e2) {
                    Log.e(TAG, "unable to close() " + mSocketType +
                            " socket during connection failure", e2);
                }
                return;
            }

            // Reset the ConnectThread because we're done
            synchronized (this) {
                mConnectThread = null;
            }

            // Start the connected thread
            connected(mmSocket, mmDevice, mSocketType);
        }

        public void cancel() {
            try {
                mmSocket.close();
            } catch (IOException e) {
                Log.e(TAG, "close() of connect " + mSocketType + " socket failed", e);
            }
        }
    }

    private class ConnectedThread extends Thread {
        private final BluetoothSocket mmSocket;
        private final InputStream mmInStream;
        private final OutputStream mmOutStream;

        public ConnectedThread(BluetoothSocket socket, String socketType) {
            Log.d(TAG, "create ConnectedThread: " + socketType);
            mmSocket = socket;
            InputStream tmpIn = null;
            OutputStream tmpOut = null;

            // Get the BluetoothSocket input and output streams
            try {
                tmpIn = socket.getInputStream();
                tmpOut = socket.getOutputStream();
            } catch (IOException e) {
                Log.e(TAG, "temp sockets not created", e);
            }

            mmInStream = tmpIn;
            mmOutStream = tmpOut;
            mSocketState = STATE_CONNECTED;
        }

        public void run() {
            Log.i(TAG, "BEGIN mConnectedThread");
            byte[] buffer = new byte[1024];
            int len;

            // Keep listening to the InputStream while connected
            while (mSocketState == STATE_CONNECTED) {
                try {
                    // Read from the InputStream
                    len = mmInStream.read(buffer);
                    String str = new String(buffer);
                    Log.i(TAG, str);

                    //tvReceivedData.setText(str);
                    showReceiveMsg(str);
                } catch (IOException e) {
                    Log.e(TAG, "disconnected", e);
                    Log.i(TAG, "Disconnected");
                    showStatusMsg("Disconnected");
                    break;
                }
            }
        }

        public void write(byte[] buffer) {
            try {
                //mmOutStream.write(buffer);
                mmOutStream.write(buffer, 0, buffer.length);
            } catch (IOException e) {
                Log.e(TAG, "Exception during write", e);
            }
        }

        public void cancel() {
            if (mmSocket == null)
                return;

            try {
                mmSocket.close();
            } catch (IOException e) {
                Log.e(TAG, "close() of connect socket failed", e);
            }
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Log.d(TAG, "### configureFlutterEngine ###");

        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "com.archi.team.gems.user");
        channel.setMethodCallHandler(handler);

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM_SELECTED_DEVICE).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink eventSink) {
                        Log.d(TAG, "### adding EventChannel selectedDeviceSink listener ###");

                        selectedDeviceSink = eventSink;
                        registerReceiver(devicePickerReceiver, new IntentFilter("android.bluetooth.devicepicker.action.DEVICE_SELECTED"));
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.d(TAG, "### cancelling EventChannel listener ###");
                        selectedDeviceSink = null;
                        try {
                            unregisterReceiver(devicePickerReceiver);
                        } catch (IllegalArgumentException ex) {
                            // Ignore `Receiver not registered` exception
                        }
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM_RECEIVE_MSG).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink eventSink) {
                        Log.d(TAG, "### adding EventChannel receiveMsgSink listener ###");

                        receiveMsgSink = eventSink;
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.d(TAG, "### cancelling EventChannel receiveMsgSink listener ###");
                        receiveMsgSink = null;
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM_RECEIVE_STRENGTH).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink eventSink) {
                        Log.d(TAG, "### adding EventChannel receiveStrengthSink listener ###");

                        receiveStrengthSink = eventSink;
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.d(TAG, "### cancelling EventChannel receiveStrengthSink listener ###");
                        receiveStrengthSink = null;
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM_RECEIVE_SPEED).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink eventSink) {
                        Log.d(TAG, "### adding EventChannel receiveSpeedSink listener ###");

                        receiveSpeedSink = eventSink;
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.d(TAG, "### cancelling EventChannel receiveSpeedSink listener ###");
                        receiveSpeedSink = null;
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM_RECEIVE_COUNT).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink eventSink) {
                        Log.d(TAG, "### adding EventChannel receiveCountSink listener ###");

                        receiveCountSink = eventSink;
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.d(TAG, "### cancelling EventChannel receiveCountSink listener ###");
                        receiveCountSink = null;
                    }
                }
        );

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM_RECEIVE_TOTAL_TIME).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink eventSink) {
                        Log.d(TAG, "### adding EventChannel receiveTotalTimeSink listener ###");

                        receiveTotalTimeSink = eventSink;
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.d(TAG, "### cancelling EventChannel receiveTotalTimeSink listener ###");
                        receiveTotalTimeSink = null;
                    }
                }
        );

    }

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        if (methodCall.method.equals("showDevicePicker")) {
            Log.d(TAG, "### showDevicePicker ###");
            //Launch built in bluetooth device picker activity
            startActivity( new Intent("android.bluetooth.devicepicker.action.LAUNCH")
                    .putExtra("android.bluetooth.devicepicker.extra.NEED_AUTH", false)
                    .putExtra("android.bluetooth.devicepicker.extra.FILTER_TYPE", 0)
                    .putExtra("android.bluetooth.devicepicker.extra.LAUNCH_PACKAGE","com.archi.team.gems.user")
                    .setFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS));
            result.success(true);

        } else if (methodCall.method.equals("setStrength")) {
            Log.d(TAG, "### setStrength ###");
            if (!methodCall.hasArgument("strength")) {
                result.error("invalid_argument", "argument 'name' not found", null);
                return;
            }

//            private int workoutMode = 0;
//            private int trainingCount = 0;
//            private int trainingTotalTime = 0;
//            private int workoutSpeed = 0;

            try {
                workoutStrength = methodCall.argument("strength");
            } catch (ClassCastException ex) {
                result.error("invalid_argument", "'name' argument is required to be string", null);
                return;
            }

            Log.d(TAG, "### setStrength ### : " + workoutStrength);

            //send data
            Calendar calendar = Calendar.getInstance();
            String todayTime = (calendar.get(Calendar.MONTH) + 1)
                    + "/" + calendar.get(Calendar.DAY_OF_MONTH)
                    + " " + calendar.get(Calendar.HOUR_OF_DAY)
                    + ":" + calendar.get(Calendar.MINUTE)
                    + ":" + calendar.get(Calendar.SECOND);

            String sendMsg = "{\"todayTime\" : \""+ todayTime + "\", \"mode\" : " + workoutMode
                    + ", \"count\" : " + trainingCount + ", \"totalTime\" : " + trainingTotalTime
                    + ", \"strength\" : " + workoutStrength + ", \"speed\" : " + workoutSpeed + "}";

            mConnectedThread.write(sendMsg.getBytes());

        } else if (methodCall.method.equals("setSpeed")) {
            Log.d(TAG, "### setSpeed ###");
            if (!methodCall.hasArgument("speed")) {
                result.error("invalid_argument", "argument 'name' not found", null);
                return;
            }

            try {
                workoutSpeed = methodCall.argument("speed");
            } catch (ClassCastException ex) {
                result.error("invalid_argument", "'name' argument is required to be string", null);
                return;
            }

            Log.d(TAG, "### setSpeed ### : " + workoutSpeed);

            //send data
            Calendar calendar = Calendar.getInstance();
            String todayTime = (calendar.get(Calendar.MONTH) + 1)
                    + "/" + calendar.get(Calendar.DAY_OF_MONTH)
                    + " " + calendar.get(Calendar.HOUR_OF_DAY)
                    + ":" + calendar.get(Calendar.MINUTE)
                    + ":" + calendar.get(Calendar.SECOND);

            String sendMsg = "{\"todayTime\" : \""+ todayTime + "\", \"mode\" : " + workoutMode
                    + ", \"count\" : " + trainingCount + ", \"totalTime\" : " + trainingTotalTime
                    + ", \"strength\" : " + workoutStrength + ", \"speed\" : " + workoutSpeed + "}";

            Log.d(TAG, "### sendMsg ### : " + sendMsg);

            mConnectedThread.write(sendMsg.getBytes());

        } else if (methodCall.method.equals("setWorkoutMode")) {
            Log.d(TAG, "### setWorkoutMode ###");
            if (!methodCall.hasArgument("mode")) {
                result.error("invalid_argument", "argument 'name' not found", null);
                return;
            }

            try {
                workoutMode = methodCall.argument("mode");
            } catch (ClassCastException ex) {
                result.error("invalid_argument", "'name' argument is required to be string", null);
                return;
            }

            Log.d(TAG, "### setWorkoutMode ### : " + workoutSpeed);

            //send data
            Calendar calendar = Calendar.getInstance();
            String todayTime = (calendar.get(Calendar.MONTH) + 1)
                    + "/" + calendar.get(Calendar.DAY_OF_MONTH)
                    + " " + calendar.get(Calendar.HOUR_OF_DAY)
                    + ":" + calendar.get(Calendar.MINUTE)
                    + ":" + calendar.get(Calendar.SECOND);

            String sendMsg = "{\"todayTime\" : \""+ todayTime + "\", \"mode\" : " + workoutMode
                    + ", \"count\" : " + trainingCount + ", \"totalTime\" : " + trainingTotalTime
                    + ", \"strength\" : " + workoutStrength + ", \"speed\" : " + workoutSpeed + "}";

            Log.d(TAG, "### sendMsg ### : " + sendMsg);

            mConnectedThread.write(sendMsg.getBytes());

        } else {
            result.notImplemented();
        }
    };

    private void showStatusMsg(final String message) {
        Handler handler = new Handler(Looper.getMainLooper()) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                selectedDeviceSink
                        .success("Name : " + selectedDeviceName + "\nConnection Status : " + message);
            }
        };
        handler.sendEmptyMessage(1);
    }

    //        private EventSink receiveStrengthSink;
//        private EventSink receiveSpeedSink;
//        private static final String STREAM_SELECTED_DEVICE = "com.archi.team.gems.user/eventSelectedDevice";
//        private static final String STREAM_RECEIVE_MSG = "com.archi.team.gems.user/eventReciveMsg";
//        private static final String STREAM_RECEIVE_STRENGTH = "com.archi.team.gems.user/eventReciveStrength";
//        private static final String STREAM_RECEIVE_SPEED = "com.archi.team.gems.user/eventReciveSpeed";
//
//    private static final String STREAM_RECEIVE_COUNT = "com.archi.team.gems.user/eventReciveCount";
//    private static final String STREAM_RECEIVE_TOTAL_TIME = "com.archi.team.gems.user/eventReciveTotalTime";

    //        private static final String STREAM_RECEIVE_COUNT = "com.archi.team.gems.user/eventReciveCount";
//        private static final String STREAM_RECEIVE_TOTAL_TIME = "com.archi.team.gems.user/eventReciveTotalTime";

//        private EventSink receiveCountSink;
//        private EventSink receiveTotalTimeSink;


    private void showReceiveMsg(final String message) {
        Handler handler = new Handler(Looper.getMainLooper()) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                receiveMsgSink.success(message);

                try {
                    JSONObject jsonObject = new JSONObject(message);
                    int newStrength, newSpeed, newCount, newTotalTime, newPower;
                    newPower = jsonObject.getInt("power");
                    newStrength = jsonObject.getInt("strength");
                    newSpeed = jsonObject.getInt("speed");
                    newCount = jsonObject.getInt("count");
                    newTotalTime = jsonObject.getInt("totalTime");

                    if (workoutStrength != newStrength) {
                        workoutStrength = newStrength;
                        //String strengthMsg = "Strength(0~3) : " + workoutStrength;
                        String strengthMsg = Integer.toString(workoutStrength);
                        receiveStrengthSink.success(strengthMsg);

                        Log.d(TAG, "### strengthMsg ### : " + strengthMsg);
                    }

                    if (workoutSpeed != newSpeed) {
                        workoutSpeed = newSpeed;
                        //String speedMsg = "Speed(1~10) : " + workoutSpeed;
                        String speedMsg = Integer.toString(workoutSpeed);
                        receiveSpeedSink.success(speedMsg);

                        Log.d(TAG, "### speedMsg ### : " + speedMsg);
                    }

                    if (trainingTotalTime != newTotalTime) {
                        trainingTotalTime = newTotalTime;
                        String totalTimeMsg = Integer.toString(trainingTotalTime);
                        receiveTotalTimeSink.success(totalTimeMsg);

                        Log.d(TAG, "### totalTimeMsg ### : " + totalTimeMsg);
                    }

                    if (trainingCount != newCount) {
                        trainingCount = newCount;
                        String countMsg = Integer.toString(trainingCount);
                        receiveCountSink.success(countMsg);

                        Log.d(TAG, "### countMsg ### : " + countMsg);
                    }

                } catch ( JSONException e){
                    Log.e(TAG, "jsonException", e);
                }
            }
        };
        handler.sendEmptyMessage(1);
    }
}
