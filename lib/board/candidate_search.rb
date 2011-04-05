module Board

  class CandidateSearch < API::Base

    DEFAULT_PER_PAGE = 10

    attr_reader :params

    def initialize(*args)
      @params = args.pop
      self.page = params[:page] || 1
      super
    end

    def each_result
      (1..total_pages).each do |page|
        self.page = page
        results.each do |result|
          yield result
        end
        clear
      end
    end

    def total_pages
      (total / per_page.to_f).ceil
    end

    def results
      response['results']
    end

    def total
      response['total']
    end

    def per_page
      params[:per_page] || DEFAULT_PER_PAGE
    end

    def page
      params[:page]
    end

    def page=(value)
      params[:page] = value
    end

    def valid?
      response && (errors.nil? || errors.size == 0)
    end

    attr_reader :errors

    private

    def clear
      @response = nil
      @errors   = nil
    end

    def response
      @response ||= get "/candidate_searches", params
    rescue RestClient::Exception => e
      @errors = decode_json(e.response)
    end

  end

end