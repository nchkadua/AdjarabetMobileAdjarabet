//
//  NotificationsProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

// Temporary Helper Class
class NotificationsProvider {
    // swiftlint:disable line_length
    public static var notificationArray = [
        Notification(id: 0, date: Date.today, title: "ესტონეთი Vs.საქართველო დღეს 20:00-ზე!", icon: R.image.notifications.temporary.icon1()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3 ", time: "2 წუთის წინ", seen: false),
        Notification(id: 1, date: Date.today, title: "სომხეთი Vs. 32საქართველო დღეს, 20:00-ზე! დადე მინ. 1₾ ქართველების გამარჯვებაზე….", icon: R.image.notifications.temporary.icon1()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "Prango. მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3 ", time: "2 საათის წინ", seen: false),
        Notification(id: 2, date: Date.today, title: "მიიღე 30% FREEBET საქართველოს მატჩზე!", icon: R.image.notifications.temporary.icon2()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3", time: "3 საათის წინ", seen: false),
        Notification(id: 3, date: Date.yesterday, title: "საქართველო Vs. ბელარუსი დღეს, 20:00-ზე! დადე მინ. 1₾ ქართველების გამარჯვებაზე….", icon: R.image.notifications.temporary.icon1()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "Prango. მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3 ", seen: true),
        Notification(id: 4, date: Date.yesterday, title: "არ გამოტოვო უეფას ერთა ლიგის მატჩები!", icon: R.image.notifications.temporary.icon2()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3 ", seen: true),
        Notification(id: 5, date: Date.bYesterday, title: "მიიღე 30% FREEBET საქართველოს მატჩზე!", icon: R.image.notifications.temporary.icon2()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3", seen: true),
        Notification(id: 6, date: Date.bYesterday, title: "ესტონეთი Vs.საქართველო დღეს 20:00-ზე!", icon: R.image.notifications.temporary.icon1()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3", seen: true),
        Notification(id: 7, date: Date.bYesterday, title: "ესტონეთი Vs.საქართველო დღეს 20:00-ზე!", icon: R.image.notifications.temporary.icon1()!, pageTitle: "აქცია სპორტში", image: R.image.notifications.temporary.cover1()!, text: "მიიღე 30% FREEBET გარანტირებულად! შეიყვანე ბილეთში მინ. 1 პოზიცია მოცემული მატჩიდან და დასაჩუქრდი ფრიბეთით. მინ. ფსონი - 1₾; მინ. კოეფიციენტი 1.3; მინ. გადაბმა - 3", seen: true)
    ]

    public static func notifications() -> [Notification] {
        notificationArray
    }

    public static func unreadNotifications() -> [Notification] {
        notificationArray.filter({ $0.seen == false })
    }

    public static func delete(at index: Int) {
        notificationArray.remove(at: index)
    }

    public static func notifications(ofDate date: Date) -> [Notification] {
        return notifications().filter {
            return $0.date == date
        }
    }

    public static func dates() -> [Date] {
        return notifications().map({ (notification: Notification) -> Date in notification.date }).uniques
    }
}

public struct Notification {
    public var id: Int
    public var date: Date
    public var title: String
    public var icon: UIImage
    public var pageTitle: String
    public var image: UIImage
    public var text: String
    public var time: String?

    public var isNew: Bool? {
        date < Date() ? false : true
    }

    public var seen: Bool
}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
