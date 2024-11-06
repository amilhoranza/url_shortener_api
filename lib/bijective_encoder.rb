# Simple bijective function
#   Basically encodes any integer into a base(n) string,
#     where n is ALPHABET.length.
#   Based on pseudocode from http://stackoverflow.com/questions/742013/how-to-code-a-url-shortener/742047#742047
class BijectiveEncoder
  ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.split(//)

  def self.bijective_encode(i)
    return ALPHABET[0] if i.zero?

    s = ''
    base = ALPHABET.length
    while i.positive?
      s << ALPHABET[i.modulo(base)]
      i /= base
    end
    s.reverse
  end

  def self.bijective_decode(s)
    i = 0
    base = ALPHABET.length
    s.each_char { |c| i = i * base + ALPHABET.index(c) }
    i
  end
end
