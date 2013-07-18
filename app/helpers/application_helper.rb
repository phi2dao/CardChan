module ApplicationHelper
  def full_title title
    if title.empty?
      "CardChan"
    else
      "CardChan | #{title}"
    end
  end

  def gravatar_for deck, options = {}
    options = {alt: deck.subject, class: 'gravatar', size: 80}.merge! options
    id = Digest::MD5::hexdigest deck.email.strip.downcase
    url = "http://www.gravatar.com/avatar/#{id}.jpg?s=#{options[:size]}&d=identicon"
    options.delete :size
    image_tag url, options
  end
end
