require 'openssl'
require 'base64'

# 固定のIVとKEY
iv = '0123456789abcdef'
key = '0123456789abcdef0123456789abcdef'

# 暗号化するデータ
data = "This is a secret message."

# UTF-8からバイナリに変換してBASE64エンコード
binary_data = data.encode('UTF-8').force_encoding('BINARY')
base64_data = Base64.encode64(binary_data)

# 暗号化
cipher = OpenSSL::Cipher.new('AES-256-CBC')
cipher.encrypt
cipher.key = key
cipher.iv = iv
encrypted = cipher.update(binary_data) + cipher.final

# 復号
cipher = OpenSSL::Cipher.new('AES-256-CBC')
cipher.decrypt
cipher.key = key
cipher.iv = iv
decrypted = cipher.update(encrypted) + cipher.final

# 復号したバイナリからUTF-8に変換して表示
puts "暗号化前のデータ: #{data}"
puts "暗号化後のデータ: #{Base64.encode64(encrypted)}"
puts "復号後のデータ: #{decrypted.force_encoding('UTF-8')}"
