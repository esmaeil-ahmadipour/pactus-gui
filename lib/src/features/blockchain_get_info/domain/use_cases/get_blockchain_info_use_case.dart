import 'package:dartz/dartz.dart';
import 'package:gui/src/data/data_sources/remote_data_state.dart';
import 'package:gui/src/data/models/error_response_model.dart';
import 'package:gui/src/data/use_cases/use_case.dart';
import 'package:gui/src/features/blockchain_get_info/domain/entities/blockchain_info_entity.dart';
import 'package:gui/src/features/blockchain_get_info/domain/repositories/blockchain_repository.dart';

class GetBlockchainInfoUseCase
    implements
        FutureUseCase<
            Either<RemoteDataState<ErrorResponseModel>,
                RemoteDataState<BlockchainInfoEntity>>,
            void> {
  GetBlockchainInfoUseCase(this._repository);
  final BlockchainRepository _repository;

  @override
  Future<
      Either<RemoteDataState<ErrorResponseModel>,
          RemoteDataState<BlockchainInfoEntity>>> call({void params}) async {
    return _repository.getBlockchainInfo();
  }
}
