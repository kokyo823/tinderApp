//
//  CardView.swift
//  MachingWithSwiftUI
//
//  Created by 杉山誇京 on 2024/10/24.
//
//　Viewファイルは「アプリのユーザーが触る画面表示」を担当するもの

import SwiftUI

struct CardView: View {
    
    // Stateプロパティラッパーによって、変数の自由な変更が可能になり、値の変更と同時に画面が再描画される
    // CGSizeプロトコルはwidth,heightを使うようなもの
    @State private var offset: CGSize = .zero
    let user: User
    
    var body: some View {
        ZStack(alignment: .bottom){
            // Background
            Color.black
            
            // image
            imageLayer
            
            // グラデーション
            // Gradient
            LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
            
            //名前や説明
            // Information
            informationLayer
            
            //　スライド時に表示されるLIKEやNOPEのステッカーアイコン
            // LIKE and NOPE
            LikeAndNope
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .offset(offset)
        .gesture(gesture)
        .scaleEffect(scale)
        .rotationEffect(.degrees(angle))
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NOPEACTION"), object: nil)){ data in
            print("List \(data)")
            
            guard
                let info = data.userInfo,
                let id = info["id"] as? String
            else {return}
            
            if id == user.id{
                removeCard(isLiked: false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LIKEACTION"), object: nil)){ data in
            print("List \(data)")
            
            guard
                let info = data.userInfo,
                let id = info["id"] as? String
            else {return}
            
            if id == user.id{
                removeCard(isLiked: true)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("REDOACTION"), object: nil)){ data in
            print("List \(data)")
            
            guard
                let info = data.userInfo,
                let id = info["id"] as? String
            else {return}
            
            if id == user.id{
                resetCard()
            }
        }
    }
}


#Preview {
    ListView()
}

// アノテーションコメントというXcodeの機能で、タグとして検出される
//　-UI部分はそれぞれの要素（画像、グラデーション、説明、LIKENOPEステッカー）それぞれのUI部分を作っている
// MARK: -UI
extension CardView{
    
    private var imageLayer: some View{
        // オプショナルの文字列を定義してる場合は、nilだったときの代わりを用意する必要がある
        Image(user.photoUrl ?? "avatar")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100)
    }
    
    private var informationLayer: some View{
        VStack(alignment: .leading){
            HStack(alignment: .bottom){
                Text(user.name)
                    .font(.largeTitle.bold())
                // String型でいれないといけないところにInt型を入れる時はString型に補正する必要がある
                Text("\(user.age)")
                    .font(.title2)
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.white, .blue)
                    .font(.title2)
            }
            if let message = user.message {
                Text(message)
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    private var LikeAndNope: some View{
        HStack{
            // LINE
            Text("LIKE")
                .tracking(4)
                .foregroundStyle(.green)
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.green, lineWidth: 5)
                }
                .rotationEffect(Angle(degrees: -15))
                .offset(x: 16, y:30)
                .opacity(opacity)
            
            Spacer()
            
            // NOPE
            Text("NOPE")
                .tracking(4)
                .foregroundStyle(.red)
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red, lineWidth: 5)
                }
                .rotationEffect(Angle(degrees: 15))
                .offset(x: -16, y:30)
                .opacity(-opacity)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

// -Action部分はアクションを定義している
// MARK: -Action
extension CardView {
    
    //　CGFloatプロトコルに準拠してscreenWidthを定義
    private var screenWidth: CGFloat{
        //　windowの幅を取得してリターンしている
        guard let window = UIApplication.shared.connectedScenes.first as?
                UIWindowScene else {return 0.0}
        return window.screen.bounds.width
    }
    
    // CGFloatは浮動小数点数型でプロットフォーム側のビット数に合わせる型
    private var scale: CGFloat{
        // 最小のスケールサイズを0.75に設定しして、widthの絶対値が移動すればするほど、スケールサイズを小さくしている
        return max(1.0 - (abs(offset.width) / screenWidth), 0.75)
    }
    
    //ドラッグした際のカードの角度をwidthをもとに調節している関数
    private var angle: Double{
        print()
        return (offset.width / screenWidth) * 10.0
    }
    
    //ドラッグした際のカードの透明度をwidthをもとに調整している関数
    private var opacity: Double{
        return offset.width / screenWidth * 4.0
    }
    
    // isLikedがTrueだったら、画面右に移動、逆は画面左に移動
    private func removeCard(isLiked: Bool, height: CGFloat = 0.0){
        withAnimation(.smooth){
            offset = CGSize(width: isLiked ? screenWidth * 1.5 : -screenWidth * 1.5, height: height)
        }
    }
    
    private func resetCard(){
        withAnimation(.smooth){
            offset = .zero
        }
    }
    
    
    private var gesture: some Gesture{
        DragGesture()
            .onChanged { value in
                let width = value.translation.width
                let height = value.translation.height
                
                let limitedHeight = height > 0 ? min(height, 100) : max(-100, height)
                
                offset = CGSize(width: width, height: limitedHeight)
            }
            .onEnded { value in
                let width = value.translation.width
                let height = value.translation.height
                
                if (abs(width) > (screenWidth / 4)){
                    removeCard(isLiked: width > 0, height: height)
                } else{
                    resetCard()
                }
            }
    }
}
