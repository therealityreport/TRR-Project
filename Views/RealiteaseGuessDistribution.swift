import SwiftUI

struct RealiteaseGuessDistributionView: View {
    @ObservedObject var viewModel: RealiteaseGuessDistributionViewModel
    @Binding var currentGuessNumber: Int?

    private let barMaxWidth: CGFloat = 300

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(1..<7, id: \.self) { guessNumber in
                HStack {
                    Text("\(guessNumber)")
                        .font(Font.custom("Poppins", size: 15).weight(.semibold))
                        .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))

                    let count = viewModel.guessDistribution[guessNumber, default: 0]
                    let totalCount = viewModel.guessDistribution.values.reduce(0, +)
                    let percentage = totalCount > 0 ? CGFloat(count) / CGFloat(totalCount) : 0

                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: percentage * barMaxWidth, height: 34)
                            .background(currentGuessNumber == guessNumber ? Color("AccentBlue") : Color("AccentBlack"))
                            .cornerRadius(10)
                        Text("\(count)")
                            .font(Font.custom("Poppins", size: 15).weight(.medium))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                    .frame(height: 27)
                    .padding(.leading, 8)
                }
                .padding(.bottom, 5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RealiteaseGuessDistributionView_Previews: PreviewProvider {
    static var previews: some View {
        RealiteaseGuessDistributionView(viewModel: RealiteaseGuessDistributionViewModel(), currentGuessNumber: .constant(3))
    }
}
