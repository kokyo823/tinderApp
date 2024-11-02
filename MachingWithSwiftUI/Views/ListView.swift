//
//  ListView.swift
//  MachingWithSwiftUI
//
//  Created by 杉山誇京 on 2024/10/24.
//
//　Viewファイルは「アプリのユーザーが触る画面表示」を担当するもの

import SwiftUI

// structはクラスに近い性質を持つデータをカプセル化し保存する機能（カプセル化：容易に外部や内部から変更できないようにする仕組み）
//　クラスも構造体も変数と関数のまとまり（クラス内で定義された変数のことを「プロパティ」関数のことを「メソッド」と呼ぶ）
//　structは継承できない&値渡し（クラスの場合は他のクラスやプロトコルを継承でき、継承元の変数や関数にアクセスできる。また、クラスは参照渡し）

// ここではListViewの設計図をViewプロトコルに準拠して作成
struct ListView: View {
    
    //　このファイル内で使える変数としてviewModelを定義
    private let viewModel = ListViewModel()
    
    //　someについては謎い。とりあえずViewプロトコルに準拠して、bodyを定義。
    var body: some View {
        // cardsとactionsを奥行きがある形で配置
        VStack(spacing: 0){
            //Cards
            cards
            
            //Actions
            actions
        }
        //　ここからはモディファイアと言われるCSSのような修飾する役割のものが並ぶ
        // .background(スタイル, in: 図形, fillStyle: FillStyle)
        // RoundedRectangleは角丸の四角形を表示するという意味
        .background(.black, in: RoundedRectangle(cornerRadius: 15))
        // 水平方向に6ポイントのパディングを設置
        .padding(.horizontal, 6)
    }
}

#Preview {
    ListView()
}

//　extensionはクラスや構造体、列挙型の機能を拡張できる
// ファイルをきれいにするために、拡張して、まとまった要素は外で描くイメージをしてる
extension ListView{
    
    // card部分のUIをViewプロトコルに準拠して作成
    private var cards: some View{
        //ZStackは奥行き方向に並べる
        ZStack{
            // ForEachの条件の中身を配列にする場合は、ユニークのプロパティを宣言する必要がある。もしくはモデル側でモデルをIdentifay型にする必要がある。
            //ForEachの引数には、viewModelで定義しているusersを逆順で設定する
            //CaedViewにuserを渡す。
            ForEach(viewModel.users.reversed()) { user in
                CardView(user: user) { isRedo in
                    viewModel.adjustIndex(isRedo: isRedo)
                }
            }
        }
    }
    //　actions部分（ボタンがある領域）のUIをViewプロトコルに準拠して作成
    private var actions: some View{
        // Hstackは水平方向に並べる（カード部分は他のファイルに切り出してるのに対し、アクション部分はこのページ内に記述）
        HStack(spacing: 60){
            Button {
                // viewModelの中で定義しているnopeButtontappedメソッドを発火させる
                viewModel.tappedHandler(action: .nope)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.red)
                    .background{
                        Circle()
                            .stroke(.red, lineWidth: 1)
                            .frame(width: 60,height: 60)
                    }
            }
            Button {
                viewModel.tappedHandler(action: .redo)
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.yellow)
                    .background{
                        Circle()
                            .stroke(.red, lineWidth: 1)
                            .frame(width: 50,height: 50)
                    }
            }
            Button {
                viewModel.tappedHandler(action: .like)
            } label: {
                Image(systemName: "heart")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.mint)
                    .background{
                        Circle()
                            .stroke(.red, lineWidth: 1)
                            .frame(width: 60,height: 60)
                    }
            }
        }
        .foregroundStyle(.white)
        .frame(height: 100)
    }
}

