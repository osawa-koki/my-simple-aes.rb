require 'optparse'
require 'openssl'
require 'base64'

# コマンドライン引数を解析
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on("-k", "--key KEY", "Encryption Key") { |v| options[:key] = v }
  opts.on("-d", "--data DATA", "Data to encrypt") { |v| options[:data] = v }
end.parse!

# KEY、データを取得
key = options[:key]
data = options[:data]

# ゼロでパディングする
if key.bytesize != 32
  key = key.ljust(32, "\x00")
end

# UTF-8からバイナリに変換してBASE64エンコード
binary_data = data.encode('UTF-8').force_encoding('BINARY')
base64_data = Base64.encode64(binary_data)

# 暗号化
cipher = OpenSSL::Cipher.new('AES-256-ECB')
cipher.encrypt
cipher.key = key
encrypted = cipher.update(binary_data) + cipher.final

# 復号
cipher = OpenSSL::Cipher.new('AES-256-ECB')
cipher.decrypt
cipher.key = key
decrypted = cipher.update(encrypted) + cipher.final

# 復号したバイナリからUTF-8に変換して表示
puts "暗号化前のデータ: #{data}"
puts "暗号化後のデータ: #{Base64.encode64(encrypted)}"
puts "復号後のデータ: #{decrypted.force_encoding('UTF-8')}"
