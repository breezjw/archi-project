
const BACKEND_URL = "http://35.216.2.238/";
const LIST_MEMBER_API =   "member/list";
const GET_MEMBER_API = "member";

String LIST_TRAINER_CLASS(String trainerId) =>  "trainer/${trainerId}/class/list";
String LIST_TRAINER_CLASS_MEMBER(String trainerId, String classId) =>  "trainer/${trainerId}/class/${classId}";
String ADD_TRAINER_CLASS(String trainerId) =>  "trainer/${trainerId}/class/create";
String DELETE_TRAINER_CLASS(String trainerId, String classId) =>  "trainer/${trainerId}/class/${classId}";
String ADD_TRAINER_CLASS_MEMBER(String trainerId, String classId) =>  "trainer/${trainerId}/class/${classId}/mapping";
String LIST_TRAINER_GEMS(String trainerId) =>  "trainer/${trainerId}/gems/list";
String ASSIGN_TRAINER_GEMS(String trainerId) =>  "trainer/${trainerId}/gems/assign";
String UNASSIGN_TRAINER_GEMS(String trainerId) =>  "trainer/${trainerId}/gems/unassign";