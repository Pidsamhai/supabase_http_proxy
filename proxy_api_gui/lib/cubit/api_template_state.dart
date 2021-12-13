part of 'api_template_cubit.dart';

abstract class ApiTemplateState {
  const ApiTemplateState();
}

class ApiTemplateInitial extends ApiTemplateState {
  const ApiTemplateInitial();
}

class ApiTemplateSuccess extends ApiTemplateState {
  final List<Template> templates;
  const ApiTemplateSuccess(this.templates);
}

class ApiTemplateLoading extends ApiTemplateState {
  const ApiTemplateLoading();
}

class ApiTemplateFailure extends ApiTemplateState {
  const ApiTemplateFailure();
}
