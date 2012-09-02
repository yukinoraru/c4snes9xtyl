#coding:utf-8
require './lib/cheat.rb'

describe Cheat do

  describe '#cheat' do
    it '複数のチート文字列を正しく解釈できるか' do
      raw = <<-CHEAT_END.gsub(/^ {8}/, '')
        #Shiawaseno udewa
        7E898401
        #Tuukonno udewa
        7E898701
        #Kaishinno udewa
        7E898601
        #Noroiyokeno udewa
        7E846701
        #Wanashino udewa
        7E894A01
        #Entouno udewa
        7E898A01
        #Konranyoke udewa
        7E898C01
        #Shikibetsu udewa
        7E898D02
        #Tuuka udewa
        7E898E01
        #Toushi udewa
        7E898301
        #Muteki joutai
        7E89A601
        #Stealth joutai
        7E871C01
        #Kaimono Flag off
        7E899000
        #CM Obake Daikon
        7E87BC11
        #CM Youkai Nigiri
        7E87BC23
        #CM Karakuroid
        7E87BC2A
        #CM Shinotukai
        7E87BC02
        #CM Dragon
        7E87BC14
        #CM Hatakearashi
        7E87BC2D
        #CM GaikotsuM
        7E87BC25
        #CM Iyashiusagi
        7E87BC16
        #CM Level1
        7E862C01
        #CM Level2
        7E862C02
        #CM Level3
        7E862C03
        #CM Tokugi siyouka
        7E89AFFF
        #Manpuku100-1
        7E8943E8
        #Manpuku100-2
        7E894403
      CHEAT_END

      cheats = Cheat.parse(raw)
      cheats.length.should == 27

      cheats.each{|c|
        c.validate.should == true
      }
    end

    it '誤ったチート文字列に対してエラーを吐けるか' do
      [
        "abc",
        "#\n\n\n",
        "#\n#\n",
        "",
        nil,
        "# \n7E898401",
        "# wrong format\n999840725"

      ].each{|c|
        cheats = Cheat.parse(c)
        cheats.length.should == 0
      }
    end

  end

end
