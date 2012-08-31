class Cheat
  public;
  attr_reader :type, :name, :code
  attr_accessor :pad

  def self.parse(raw)
    if raw == nil || raw.length < 10
      return []
    end
    cheats = []
    lines = raw.split("\n")
    lines.each_with_index{|line, i|
      # skip lines
      # TODO: regexp is not correct.
      next if !(line =~ /^#[ \w\W]+$/)
      if i+1 < lines.length
        name  = line[1..-1].strip
        body  = lines[i+1]
        if name.length > 0 && body.length == 8
          cheat = Cheat.new(name, body)
          cheats << cheat
        end
      end
    }
    return cheats
  end

  # それぞれ十六進表記の文字列
  def initialize(name, code, pad = "000000", type="08")
    @type = type
    @pad  = pad
    @name = name
    if (name.length >= 20)
    	name[19] = 0x00
    end
    @code = code
  end
  # コードが文法的に正しいかチェック(正しければtrue)
  def validate()
	if (@code.scan(/[\dA-Fa-f]{2,2}/).length != 4)
		return 1
	elsif (@type.length != 2)
		return 2
	elsif (@pad.length != 6)
		return 3
	elsif (@name.length >= 20 || @name.length == 0)
		return 4
	elsif (@code.length != 8)
		return 5
	end
	return true
  end
  # バイナリコードを取得する(数値配列で返却)
  def getbin
	tmp = ""
	tmp << @type
	tmp << @code.scan(/[\dA-Fa-f]{2,2}/).reverse.to_s
	tmp << @pad
	tmp = [tmp].pack('H*')
	@name.each_byte{|c| tmp << c}

	until (tmp.length >= 28) do
		tmp << 0x00
	end

  	return tmp
  end
end

##########################################################
# Memo:
##########################################################
# Snes9xTYLチートのフォーマット
#　　　　　+---+---------+-------+---------------------+
#　名前　　| A |    B    |   C   |          D          |
#　　　　　+---+---------+-------+---------------------+
#　長さ　　| 1 |    4    |   3   |         20          |
#　　　　　+---+---------+-------+---------------------+
#　　　　　0x00                                     0x18
#　　　　　＊長さの単位はオクテット
#
#   A ------> ENABLE: チートが有効化どうか
#   B ------> CODE: 改造コードがリトルエンディアンで格納されている
#   C ------> SAVED_BYTE : 前回の値の長さと、前回の値
#   D ------> NAME: 改造コードの名前。任意で20文字が最大か。
#
#
# 該当ソースの抜粋:
#struct SCheat
#{
#    uint32  address;
#    uint8   byte;
#    uint8   saved_byte;
#    bool8   enabled;
#    bool8   saved;
#    char    name [22];
#};
#define MAX_CHEATS 24
#
#    uint8 data [28];
#    while (fread ((void *) data, 1, 28, fs) == 28)
#    {
#	Cheat.c [Cheat.num_cheats].enabled = (data [0] & 4) == 0;
#	Cheat.c [Cheat.num_cheats].byte = data [1];
#	Cheat.c [Cheat.num_cheats].address = data [2] | (data [3] << 8) |  (data [4] << 16);
#	Cheat.c [Cheat.num_cheats].saved_byte = data [5];
#	Cheat.c [Cheat.num_cheats].saved = (data [0] & 8) != 0;
#	memmove (Cheat.c [Cheat.num_cheats].name, &data [8], 20);
#	Cheat.c [Cheat.num_cheats++].name [20] = 0;
#   }
#  fclose (fs);

