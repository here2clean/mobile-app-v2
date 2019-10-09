class H2CApiRoutes {
  static const String getAllEvents =
      "http://heretoclean.cambar.re/api/event/all";
  static const String getAllAssociations =
      "http://heretoclean.cambar.re/api/association/all";
  static const String getAllEventsByAssociation = "/api/event/allByAssociation";
  static const String addAVolunteerToAnEvent = "/api/event/addVolunteer";
  static const String removeAVolunteerFromAnEvent = "/api/event/removeVolunteer";
  static const String getEventsOfAVolunteer = "/api/volunteer/allEvent";



  static const String getVolunteerByMail = "/api/volunteer/findByEmail";



  static const String HereToClean = "heretoclean.cambar.re";
}
