//
//  FAQDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 22.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct FAQDTO: DataTransferResponse {
    struct Body: Codable {
        let categories: [FAQCategory]?

        struct FAQCategory: Codable {
            var icon: String?
            var title: String?
            var description: String?
            let questions: [FAQQuestion]?

            struct FAQQuestion: Codable {
                var title: String?
                var answer: String?

                enum CodingKeys: String, CodingKey {
                    case title
                    case answer
                }
            }

            enum CodingKeys: String, CodingKey {
                case icon
                case title
                case description
                case questions
            }
        }

        enum CodingKeys: String, CodingKey {
            case categories = "faq"
        }
    }

    typealias Entity = FAQEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let list = body.categories else {return nil}
        var categories: [FAQCategory] = []

        list.forEach {
            if let icon = $0.icon,
               let title = $0.title,
               let description = $0.description {
                var questions: [FAQQuestion] = []
                $0.questions?.forEach {
                    if let questionTitle = $0.title,
                       let questionAnswer = $0.answer {
                        let question = FAQQuestion(title: questionTitle, answer: questionAnswer)
                        questions.append(question)
                    }
                }
                let category = FAQCategory(icon: icon, title: title, description: description, questions: questions)
                categories.append(category)
            }
        }

        return .success(.init(categories: categories))
    }
}
