module ApplicationHelper
  def shorten_string(text, length=35)
    if text.length > length
      return text[0..length-3] + '...'
    else
      return text
    end
  end
end
