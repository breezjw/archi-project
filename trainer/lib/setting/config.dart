
const BACKEND_URL = "http://35.216.2.238/";
const LIST_MEMBER_API =   "member/list";
const GET_MEMBER_API = "member";

String LIST_TRAINER_CLASS_LIST(String trainerId) =>  "trainer/${trainerId}/class/list";
String LIST_TRAINER_CLASS_MEMBER_LIST(String trainerId, String classId) =>  "trainer/${trainerId}/class/${classId}";
String ADD_TRAINER_CLASS(String trainerId) =>  "trainer/${trainerId}/class/create";
String DELETE_TRAINER_CLASS(String trainerId, String classId) =>  "trainer/${trainerId}/class/${classId}";
String ADD_TRAINER_CLASS_MEMBER(String trainerId, String classId) =>  "trainer/${trainerId}/class/${classId}/mapping";