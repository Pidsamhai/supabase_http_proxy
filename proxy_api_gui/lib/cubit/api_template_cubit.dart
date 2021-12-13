import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';

part 'api_template_state.dart';

class ApiTemplateCubit extends Cubit<ApiTemplateState> {
  final ApiTemplateRepository _repository;
  ApiTemplateCubit(this._repository) : super(const ApiTemplateInitial());

  Future<void> init() async {
    try {
      final templates = await _repository.getTemplates();
      print(templates);
      emit(ApiTemplateSuccess(templates));
    } catch (e) {
      emit(const ApiTemplateFailure());
    }
  }
}
