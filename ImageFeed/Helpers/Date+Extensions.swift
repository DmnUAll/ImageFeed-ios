import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "ru_ru")
    return formatter
}()

extension Date {
    var dateTimeString: String { String(dateFormatter.string(from: self).dropLast(3)) }
}
