require 'twitter_search'

class TwitterPictures

  class TwitpicAdapter
    def self.match?(url)
      !(url =~ /twitpic\.com/).nil?
    end

    def self.html(url, text)
      uri = URI.parse(url) 
      id = uri.path
      "<a href=\"#{url}\"><img src=\"http://twitpic.com/show/thumb/#{id}.jpg\" title=\"#{text}\"/></a>"
    end
  end

  class YfrogAdapter
    def self.match?(url)
      !(url =~ /yfrog\.com/).nil?
    end

    def self.html(url, text)
      uri = URI.parse(url) 
      id = uri.path
      "<a href=\"#{url}\"><img src=\"http://yfrog.com#{id}:small\" title=\"#{text}\"/></a>"
    end
  end

  class PlixiAdapter
    def self.match?(url)
      !(url =~ /plixi\.com/).nil?
    end

    def self.html(url, text)
      "<a href=\"#{url}\"><img src=\"http://api.plixi.com/api/tpapi.svc/imagefromurl?size=small&url=#{url}\" title=\"#{text}\" /></a>"
    end
  end


  def self.for_users(users)
    tweets = fetch_tweets(users)
    build_pictures_html(tweets)
  end

  private
  
    def self.extract_urls(text, urls = [])
      url_regex =  Regexp.new('\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))')
      url_regex.match(text) do |match|
        urls << match[0]
        extract_urls(match.post_match, urls)
      end
      urls
    end

    def self.build_pictures_html(tweets)
      pictures = {}
      tweets.each do |t|
        pictures_for_text = build_picture_html("from @#{t.from_user}: #{t.text}")
        pictures.merge!(pictures_for_text)
      end
      pictures.values
    end
  
    def self.fetch_tweets(users)
      @client = TwitterSearch::Client.new 'http://forwardtechnology.co.uk/'
      users_query = users.join(' OR ')
      query = "http (#{users_query})"
      @client.query :q => query, :rpp => '50'
    end

    def self.build_picture_html(text)
      adapters = [TwitpicAdapter, PlixiAdapter, YfrogAdapter]
      pictures = {}
      urls = extract_urls(text)
      urls.each do |url|
        adapters.each do |adapter|
          pictures[url] = adapter.html(url, text) if adapter.match? url
        end
      end
      pictures
    end
  
end