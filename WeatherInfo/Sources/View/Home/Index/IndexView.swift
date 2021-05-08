import SwiftUI

struct ContentView: View {

    var body: some View {
        HStack{
            VStack{
            Image("index1")
                .resizable()
                .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("全く乾かない")
                    .font(.custom("SystemFont", size: 9))
                    .fontWeight(.medium)
            }
            Spacer()
            VStack{
            Image("index2")
                .resizable()
                .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("　乾かない　")
                    .font(.custom("SystemFont", size: 9))
                    .fontWeight(.medium)
            }
            Spacer()
            VStack{
            Image("index3")
                .resizable()
                .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("　やや乾く　")
                   .font(.custom("SystemFont", size: 9))
                    .fontWeight(.medium)
            }
            Spacer()
            VStack{
            Image("index4")
                .resizable()
                .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("　　乾く　　")
                    .font(.custom("SystemFont", size: 9))
                    .fontWeight(.medium)
            }
            Spacer()
            VStack{
            Image("index5")
                .resizable()
                .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("　よく乾く　")
                    .font(.custom("SystemFont", size: 9))
                    .fontWeight(.medium)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 320, height: 40))
    }
}
