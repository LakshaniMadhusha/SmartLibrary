// Models/Seat.swift
import Foundation

struct LibraryHall: Identifiable, Codable {
    let id: UUID
    var name: String
    var floor: Int
    var totalSeats: Int
    var availableSeats: Int
    var seats: [Seat]
    var openingTime: String
    var closingTime: String
    var hasWifi: Bool
    var hasCharging: Bool
    var isQuietZone: Bool

    var occupancyRate: Double {
        guard totalSeats > 0 else { return 0 }
        return Double(totalSeats - availableSeats) / Double(totalSeats)
    }

    struct Seat: Identifiable, Codable {
        let id: UUID
        var seatNumber: String
        var row: Int
        var column: Int
        var status: SeatStatus
        var reservedBy: UUID?
        var reservedUntil: Date?

        enum SeatStatus: String, Codable {
            case available = "Available"
            case occupied = "Occupied"
            case reserved = "Reserved"
            case maintenance = "Maintenance"
        }

        init(
            id: UUID = UUID(),
            seatNumber: String,
            row: Int,
            column: Int,
            status: SeatStatus = .available,
            reservedBy: UUID? = nil,
            reservedUntil: Date? = nil
        ) {
            self.id = id
            self.seatNumber = seatNumber
            self.row = row
            self.column = column
            self.status = status
            self.reservedBy = reservedBy
            self.reservedUntil = reservedUntil
        }
    }

    init(
        id: UUID = UUID(),
        name: String,
        floor: Int,
        totalSeats: Int,
        availableSeats: Int,
        seats: [Seat] = [],
        openingTime: String = "8:00 AM",
        closingTime: String = "10:00 PM",
        hasWifi: Bool = true,
        hasCharging: Bool = true,
        isQuietZone: Bool = false
    ) {
        self.id = id
        self.name = name
        self.floor = floor
        self.totalSeats = totalSeats
        self.availableSeats = availableSeats
        self.seats = seats
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.hasWifi = hasWifi
        self.hasCharging = hasCharging
        self.isQuietZone = isQuietZone
    }
}

// MARK: - Sample Data
extension LibraryHall {
    static func generateSeats(rows: Int, cols: Int) -> [Seat] {
        var seats: [Seat] = []
        let statuses: [Seat.SeatStatus] = [.available, .available, .available, .occupied, .reserved]
        for row in 0..<rows {
            for col in 0..<cols {
                let number = "\(Character(UnicodeScalar(65 + row)!))\(col + 1)"
                seats.append(Seat(
                    seatNumber: number,
                    row: row,
                    column: col,
                    status: statuses.randomElement() ?? .available
                ))
            }
        }
        return seats
    }

    static let sampleHalls: [LibraryHall] = [
        LibraryHall(
            name: "Reading Room A",
            floor: 1,
            totalSeats: 40,
            availableSeats: 24,
            seats: generateSeats(rows: 5, cols: 8),
            isQuietZone: true
        ),
        LibraryHall(
            name: "Study Hall B",
            floor: 2,
            totalSeats: 60,
            availableSeats: 35,
            seats: generateSeats(rows: 6, cols: 10),
            hasCharging: true
        ),
        LibraryHall(
            name: "Group Study Room",
            floor: 1,
            totalSeats: 20,
            availableSeats: 8,
            seats: generateSeats(rows: 4, cols: 5),
            openingTime: "9:00 AM",
            closingTime: "8:00 PM"
        )
    ]
}

