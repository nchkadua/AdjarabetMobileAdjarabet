//
//  PromotionsProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class PromotionsProvider {
    public static func temporaryData() -> [Promotion] {
        return [
            Promotion(title: "გამოცადე გართობის სრული ასორტიმენტი უფასოდ!", cover: R.image.promotions.temporary.public.cover1()!, icon: R.image.promotions.sport_icon()!),
            Promotion(title: "გამოცადე გართობის სრული ასორტიმენტი უფასოდ!", cover: R.image.promotions.temporary.public.cover2()!, icon: R.image.promotions.sport_icon()!),
            Promotion(title: "გამოცადე გართობის სრული ასორტიმენტი უფასოდ!", cover: R.image.promotions.temporary.public.cover3()!, icon: R.image.promotions.sport_icon()!),
            Promotion(title: "უკვე გამოცადე საჰაერო რბოლა აჭარაბეთზე?", cover: R.image.promotions.temporary.public.cover4()!, icon: R.image.promotions.casino_icon()!),
            Promotion(title: "უკვე გამოცადე საჰაერო რბოლა აჭარაბეთზე?", cover: R.image.promotions.temporary.public.cover5()!, icon: R.image.promotions.casino_icon()!)
        ]
    }
}

public struct Promotion {
    public var title: String
    public var cover: UIImage
    public var icon: UIImage
}
