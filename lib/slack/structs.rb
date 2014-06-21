require 'json'

class Struct
  def to_map
    map = Hash.new
    self.members.each { |m| map[m] = self[m] }
    map
  end

  def to_json(*a)
    to_map.to_json(*a)
  end
end

Attachment = Struct.new(:fallback, :text, :pretext, :color, :mrkdwn_in, :fields)
AttachmentField = Struct.new(:title, :value, :short)
