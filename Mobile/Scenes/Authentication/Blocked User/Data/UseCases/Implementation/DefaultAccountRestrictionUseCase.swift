//
//  DefaultAccountRestrictionUseCase.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 10.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class DefaultAccountRestrictionUseCase: AccountRestrictionUseCase {
    @Inject(from: .repositories) private var accountAccessLimitRepository: AccountAccessLimitRepository
    @Inject(from: .repositories) private var userInfoRepository: UserInfoReadableRepository

    func getStatus(completion: @escaping Handler) {
        let dateFormatter = ABDateFormater(with: .verbose)

        let group = DispatchGroup()

        // nil if failed
        var restrictions: [AccountRestriction?] = [ nil, nil, nil ]

        // currentUserInfo

        group.enter()
        userInfoRepository.currentUserInfo(params: .init()) { result in
            defer { group.leave() }

            let index = 0

            switch result {
            case .success(let entity):
                if let statusId = entity.statusId, let suspendTill = entity.suspendTill {
                    let status = AccountRestrictionType(rawValue: statusId)
                    if let status = status, let until = dateFormatter.date(from: suspendTill) {
                        restrictions[index] = .some(.init(type: status, until: until))
                    } else {
                        restrictions[index] = .some(.init(type: .noneBlocked, until: nil))
                    }
                } else {
                    restrictions[index] = .some(.init(type: .noneBlocked, until: nil))
                }
            case .failure(let error): restrictions[index] = nil
            }
        }

        // selfExclusion

        group.enter()
        accountAccessLimitRepository.execute(limitType: .selfExclusion) { result in
            defer { group.leave() }

            let index = 1

            switch result {
            case .success(let entity):
                if let limit = entity.limit {
                    if let until = dateFormatter.date(from: limit.periodEndDate) {
                        restrictions[index] = .some(.init(type: .fullyBlocked, until: until))
                    } else {
                        print("Error during parcing limit's periodEndDate in ABDateFormater")
                    }
                } else {
                    restrictions[index] = .some(.init(type: .noneBlocked, until: nil))
                }
            case .failure(let error):
                restrictions[index] = nil
            }
        }

        // selfSuspension

        group.enter()
        accountAccessLimitRepository.execute(limitType: .selfSuspension) { result in
            defer { group.leave() }

            let index = 2

            switch result {
            case .success(let entity):
                if let limit = entity.limit {
                    if let until = dateFormatter.date(from: limit.periodEndDate) {
                        restrictions[index] = .some(.init(type: .fullyBlocked, until: until))
                    } else {
                        print("Error during parcing limit's periodEndDate in ABDateFormater")
                    }
                } else {
                    restrictions[index] = .some(.init(type: .noneBlocked, until: nil))
                }
            case .failure(let error):
                restrictions[index] = nil
            }
        }

        group.notify(queue: .main) {
            for restriction in restrictions where restriction == nil {
                completion(.failure(.init()))
            }

            completion(.success(self.merge(restrictions: restrictions.compactMap { $0 })))
        }
    }

    private func merge(restrictions: [AccountRestriction]) -> AccountRestriction {
        for restriction in restrictions where restriction.type != .noneBlocked {
            return restriction
        }

        return .init(type: .noneBlocked, until: .none)
    }
}
