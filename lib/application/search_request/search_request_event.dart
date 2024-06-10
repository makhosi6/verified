part of 'search_request_bloc.dart';

@freezed
class SearchRequestEvent with _$SearchRequestEvent {
  const factory SearchRequestEvent.createPersonalDetails(SearchPerson person) = CreatePersonalDetails;
  const factory SearchRequestEvent.createVerifieeDetails(VerifeeRequest verifiee) = CreateVerifieeDetails;
  const factory SearchRequestEvent.selectJobsOrService(List<String> serviceOrJob) = SelectJobsOrService;
  const factory SearchRequestEvent.validateAndSubmit() = ValidateAndSubmit;

}