//
//  MessagesView.swift
//  Lab14IntroFirebase
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @StateObject private var databaseService = DatabaseService()
    @State private var newMessage = ""

    private var currentEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            // Lista de mensajes
            ScrollViewReader { proxy in
                ScrollView {
                    if databaseService.messages.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(databaseService.messages) { message in
                                MessageBubble(message: message,
                                              isMine: message.userEmail == currentEmail)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                }
                .background(Color(.systemGroupedBackground))
                .onChange(of: databaseService.messages.count) {
                    if let last = databaseService.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            inputBar
        }
        .onAppear {
            databaseService.startListening()
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            AvatarView(email: currentEmail, size: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text("Chat Lab 14")
                    .font(.headline)
                HStack(spacing: 4) {
                    Circle().fill(.green).frame(width: 8, height: 8)
                    Text(currentEmail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button {
                try? Auth.auth().signOut()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(width: 42, height: 42)
                    .background(Color.red.opacity(0.1), in: Circle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }

    // MARK: - Estado vacío
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 50))
                .foregroundStyle(.gray.opacity(0.5))
            Text("Aún no hay mensajes")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("¡Escribe el primero!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 120)
    }

    // MARK: - Barra para escribir
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Escribe un mensaje...", text: $newMessage, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 22))

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        newMessage.trimmingCharacters(in: .whitespaces).isEmpty
                            ? Color.gray.opacity(0.4)
                            : Color(red: 0.38, green: 0.25, blue: 0.95),
                        in: Circle()
                    )
            }
            .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .top)
    }

    private func sendMessage() {
        let text = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        databaseService.addMessage(text: text)
        newMessage = ""
    }
}

// MARK: - Burbuja de mensaje
struct MessageBubble: View {
    let message: Message
    let isMine: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isMine {
                Spacer(minLength: 50)
            } else {
                AvatarView(email: message.userEmail, size: 32)
            }

            VStack(alignment: isMine ? .trailing : .leading, spacing: 4) {
                if !isMine {
                    Text(message.userEmail)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                Text(message.text)
                    .font(.body)
                    .foregroundStyle(isMine ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        isMine
                            ? AnyShapeStyle(LinearGradient(
                                colors: [Color(red: 0.38, green: 0.25, blue: 0.95),
                                         Color(red: 0.10, green: 0.60, blue: 0.98)],
                                startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(Color(.systemBackground)),
                        in: RoundedRectangle(cornerRadius: 18)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 1)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if !isMine {
                Spacer(minLength: 50)
            }
        }
    }
}

// MARK: - Avatar con inicial
struct AvatarView: View {
    let email: String
    let size: CGFloat

    var body: some View {
        Text(String(email.prefix(1)).uppercased())
            .font(.system(size: size * 0.42, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(
                LinearGradient(colors: [.orange, .pink],
                               startPoint: .topLeading, endPoint: .bottomTrailing),
                in: Circle()
            )
    }
}

#Preview {
    MessagesView()
}
