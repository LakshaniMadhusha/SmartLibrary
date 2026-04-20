// Views/SeatsView.swift
import SwiftUI

struct SeatsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @ObservedObject var controller: SeatsController
    @State private var selectedSeat: LibraryHall.Seat? = nil
    @State private var showBiometricConfirmation = false
    @State private var seatToReserve: LibraryHall.Seat? = nil
    @State private var isAuthenticating = false
    @State private var authError: String? = nil

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {

                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Find a Seat")
                            .font(AppTheme.Fonts.largeTitle)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Text("Select a hall and reserve your spot")
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.horizontal, AppTheme.Spacing.base)
                    .padding(.top, AppTheme.Spacing.base)

                    // MARK: - Hall Picker
                    hallPicker

                    // MARK: - Selected Hall Info
                    if let hall = controller.selectedHall {
                        hallInfoCard(hall: hall)
                            .padding(.horizontal, AppTheme.Spacing.base)

                        // MARK: - Seat Legend
                        seatLegend
                            .padding(.horizontal, AppTheme.Spacing.base)

                        // MARK: - Seat Map
                        seatMap(hall: hall)
                            .padding(.horizontal, AppTheme.Spacing.base)

                        // MARK: - Book Button
                        if selectedSeat != nil {
                            PrimaryButton(
                                title: "Reserve Seat \(selectedSeat?.seatNumber ?? "")",
                                action: {
                                    seatToReserve = selectedSeat
                                    showBiometricConfirmation = true
                                }
                            )
                            .padding(.horizontal, AppTheme.Spacing.base)
                        }
                    }

                    Spacer(minLength: AppTheme.Spacing.xxxl)
                }
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showBiometricConfirmation) {
            BiometricReservationConfirmation(
                isPresented: $showBiometricConfirmation,
                seatNumber: seatToReserve?.seatNumber ?? "",
                authManager: authManager,
                isAuthenticating: $isAuthenticating,
                authError: $authError,
                onConfirm: {
                    if let seat = seatToReserve {
                        controller.reserveSeat(seat)
                        selectedSeat = nil
                    }
                }
            )
        }
    }

    // MARK: - Hall Picker
    private var hallPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(controller.halls) { hall in
                    hallPickerCard(hall: hall)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.base)
        }
    }

    private func hallPickerCard(hall: LibraryHall) -> some View {
        let isSelected = controller.selectedHall?.id == hall.id
        return Button(action: { controller.selectHall(hall) }) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    Image(systemName: "building.2")
                        .font(AppTheme.Fonts.custom(size: 18))
                        .foregroundColor(isSelected ? AppTheme.Colors.textOnAccent : AppTheme.Colors.accent)
                    Spacer()
                    if hall.isQuietZone {
                        Image(systemName: "speaker.slash")
                            .font(AppTheme.Fonts.custom(size: 12))
                            .foregroundColor(isSelected ? AppTheme.Colors.textOnAccent.opacity(0.7) : AppTheme.Colors.textTertiary)
                    }
                }
                Text(hall.name)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(isSelected ? AppTheme.Colors.textOnAccent : AppTheme.Colors.textPrimary)
                    .lineLimit(1)
                Text("Floor \(hall.floor)")
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(isSelected ? AppTheme.Colors.textOnAccent.opacity(0.7) : AppTheme.Colors.textSecondary)

                HStack(spacing: 4) {
                    Circle()
                        .fill(hall.availableSeats > 0 ? AppTheme.Colors.available : AppTheme.Colors.borrowed)
                        .frame(width: 6, height: 6)
                    Text("\(hall.availableSeats) free")
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(isSelected ? AppTheme.Colors.textOnAccent : AppTheme.Colors.textSecondary)
                }
            }
            .padding(AppTheme.Spacing.md)
            .frame(width: 140)
            .background(isSelected ? AppTheme.Colors.accent : AppTheme.Colors.backgroundCard)
            .cornerRadius(AppTheme.Radius.lg)
            .shadow(color: isSelected ? AppTheme.Colors.accent.opacity(0.3) : AppTheme.Colors.shadow, radius: 8, x: 0, y: 4)
        }
    }

    // MARK: - Hall Info Card
    private func hallInfoCard(hall: LibraryHall) -> some View {
        HStack(spacing: AppTheme.Spacing.xl) {
            infoItem(value: "\(hall.availableSeats)", label: "Available", icon: "chair", color: AppTheme.Colors.available)
            Divider().frame(height: 40)
            infoItem(value: "\(hall.totalSeats - hall.availableSeats)", label: "Occupied", icon: "person.fill", color: AppTheme.Colors.borrowed)
            Divider().frame(height: 40)
            infoItem(value: hall.openingTime, label: "Opens", icon: "clock", color: AppTheme.Colors.reserved)
        }
        .padding(AppTheme.Spacing.lg)
        .cardStyle()
    }

    private func infoItem(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(AppTheme.Fonts.custom(size: 14))
                .foregroundColor(color)
            Text(value)
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.textPrimary)
            Text(label)
                .font(AppTheme.Fonts.caption2)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Seat Legend
    private var seatLegend: some View {
        HStack(spacing: AppTheme.Spacing.lg) {
            legendItem(color: AppTheme.Colors.seatAvailable, label: "Available")
            legendItem(color: AppTheme.Colors.seatOccupied, label: "Occupied")
            legendItem(color: AppTheme.Colors.seatReserved, label: "Reserved")
            legendItem(color: AppTheme.Colors.seatSelected, label: "Selected")
        }
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 14, height: 14)
            Text(label)
                .font(AppTheme.Fonts.caption2)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }

    // MARK: - Seat Map
    private func seatMap(hall: LibraryHall) -> some View {
        let cols = 8
        let rows = (hall.seats.count + cols - 1) / cols
        let seatsByRow = (0..<rows).map { row in
            hall.seats.filter { $0.row == row }
        }

        return VStack(spacing: AppTheme.Spacing.sm) {
            // Stage/Front label
            HStack {
                Spacer()
                Text("FRONT")
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(AppTheme.Colors.backgroundSecondary)
                    .cornerRadius(AppTheme.Radius.sm)
                Spacer()
            }
            .padding(.bottom, AppTheme.Spacing.sm)

            ForEach(0..<min(rows, seatsByRow.count), id: \.self) { rowIdx in
                HStack(spacing: AppTheme.Spacing.xs) {
                    Text("\(rowIdx + 1)")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.textTertiary)
                        .frame(width: 16)
                    ForEach(seatsByRow[rowIdx]) { seat in
                        seatButton(seat: seat)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .cardStyle()
    }

    private func seatButton(seat: LibraryHall.Seat) -> some View {
        let isSelected = selectedSeat?.id == seat.id
        let color = seatColor(seat: seat, isSelected: isSelected)
        let isDisabled = seat.status == .occupied || seat.status == .maintenance

        return Button(action: {
            guard !isDisabled else { return }
            selectedSeat = isSelected ? nil : seat
        }) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    Text(seat.seatNumber.suffix(1))
                        .font(AppTheme.Fonts.custom(size: 9, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppTheme.Colors.textPrimary.opacity(0.7))
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.spring(response: 0.3), value: isSelected)
        }
        .disabled(isDisabled)
    }

    private func seatColor(seat: LibraryHall.Seat, isSelected: Bool) -> Color {
        if isSelected { return AppTheme.Colors.seatSelected }
        switch seat.status {
        case .available:    return AppTheme.Colors.seatAvailable
        case .occupied:     return AppTheme.Colors.seatOccupied
        case .reserved:     return AppTheme.Colors.seatReserved
        case .maintenance:  return AppTheme.Colors.border
        }
    }
}

