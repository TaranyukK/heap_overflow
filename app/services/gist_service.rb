class GistService
  def initialize(url, client: default_client)
    @url = url
    @client = client
    @gist = load_gist
  end

  def call
    if @errors.nil?
      @gist.files.map { |_, file| file[:content] }
    else
      ['Not found']
    end
  end

  private

  def gist_id
    @url.split('/').last
  end

  def load_gist
    @client.gist(gist_id)
  rescue Octokit::NotFound => e
    @errors = e
  end

  def default_client
    Octokit::Client.new
  end
end
