class PapersController < ApplicationController

  def potC
    @author_pairs = [
        ["Hogg","Goodman"],
        ["Hogg","Blanton"],
        ["Hogg","Cranmer"],
        ["Hogg","Fergus"],
        ["Hogg","Huppenkothen"],
        ["Hogg","Greengard"],
        ["Fergus","LeCun"],
        ["Goodman","Hill"],
        ["Hill","Scott"],
        ["Deo","Hurvich"],
        ["Hurvich","Simonoff"],
        ["Shasha","Freire"],
        ["Freire","Silva"],
        ["Kolm","Mishra"]
      ]
    @papers = Paper.all
    @coauthors_string = []
    @coauthors_ids = []
#..add    @matchedPapers = MatchedPaper.all
    @arxiv_papers = []
    @arxiv_json = []
    @elsevier_papers = []
    @pairs = []
    @matches = []
    @json = []
    require 'rss/nokogiri'
    require "httparty"
    @author_pairs.each_with_index do |ap,i|
      @pairs[i] = Author.find_all_by_last(ap)
      @coauthors_string[i] = @pairs[i].map{|author| author.name }.join(", ")
      @coauthors_ids = @pairs[i].map{|author| author.id}.join(",")
      @matches[i] = (@pairs[i][0].papers & @pairs[i][1].papers).reject{|paper| paper.archive !~ /arXiv/}.map{|paper| paper.title + " => " + paper.matchedPaper.title }
      @arxiv_query = "http://export.arxiv.org/api/query?search_query=au:" + @pairs[i][0].last + "_" + @pairs[i][0].first[0] + "+AND+au:" + @pairs[i][1].last + "_" + @pairs[i][1].first[0] 
      @arxiv_query.gsub!(" ","+")
      arxiv_rss = RSS::Parser.parse(open(@arxiv_query).read, do_validate=false).entries.reject{|entry| (@pairs[i][0].papers & @pairs[i][1].papers).reject{|paper| paper.archive !~ /arXiv/}.map{|paper| paper.title}.include? entry.title.to_s.gsub!(/\<.*?\>/,"") }
      @arxiv_papers[i] = arxiv_rss.map{|entry| Hash.from_xml(entry.to_s)}
      @arxiv_papers[i].map{|a| a['entry']['title'].gsub!(/[\r\n]+/,"") if (a['entry']['title'] =~ /[\r\n]/)} 
      @arxiv_papers[i].each do |a|
        a['entry'].delete('summary')
      end
#      puts @arxiv_papers[i].to_s
#      @arxiv_papers[i].map{|a| a['entry']['title'].gsub!(/\r/,"").gsub!(/\n/)}
      @elsevier_query = "https://api.elsevier.com/content/search/scopus?insttoken=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&apiKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&query=au-id("+@pairs[i][0].elsevier_id+")+AND+au-id("+@pairs[i][1].elsevier_id+")"
#..@elsevier_papers[i].each_with_index.map{|paper,j| [j, paper["dc:title"]
      begin
        response = HTTParty.get(@elsevier_query)
        @json[i] = JSON.parse(response.body)
        papers_array = (@pairs[i][0].papers & @pairs[i][1].papers).reject{|paper| paper.archive !~ /arXiv/}
        @elsevier_papers[i] = @json[i]["search-results"]["entry"].reject{|paper| papers_array.map{|p| p.matchedPaper.title}.include? paper["dc:title"]}
     rescue Exception => e  
        @elsevier_papers[i] = ["Exception occurred: " + e.to_s]
      end
    end
#    require 'open-uri'
#    @arxiv_papers = RSS::Parser.parse(open(@arxiv_query))

#    require "rss"

  end

  def arxiv
    @papers = Paper.all
    @random_author = Author.offset(rand(Author.count)).first
    @author_pair = [@random_author,@random_author]
    while @author_pair[0] == @author_pair[1]
      @author_pair[1] = Author.offset(rand(Author.count)).first
    end
    @arxiv_query = "http://export.arxiv.org/api/query?search_query=au:" + @author_pair[0].last + "_" + @author_pair[0].first[0] + "+AND+au:" + @author_pair[1].last + "_" + @author_pair[1].first[0] 
    @arxiv_query.gsub!(" ","+")
#    require 'rss/nokogiri'
#    require 'open-uri'
#    @arxiv_papers = RSS::Parser.parse(open(@arxiv_query))

#    require "rss"
    @arxiv_papers = RSS::Parser.parse(open(@arxiv_query).read, false)

  end

  # GET /papers
  # GET /papers.json
  def index
    @papers = Paper.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @papers }
    end
  end

  # GET /papers/1
  # GET /papers/1.json
  def show
    @paper = Paper.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @paper }
    end
  end

  # GET /papers/new
  # GET /papers/new.json
  def new
    @paper = Paper.respond_to

    new do |format|
      format.html # new.html.erb
      format.json { render json: @paper }
    end
  end

  # GET /papers/1/edit
  def edit
    @paper = Paper.find(params[:id])
  end

  # POST /papers
  # POST /papers.json
  def create
#    @paper = Paper.new
#    @paper.title = params[:paper][:title]
#    @paper.archive = params[:paper][:archive]
#    @paper.source_id = params[:paper][:source_id]
#    @paper.pub_date = params[:paper][:pub_date]
#    @matchedPaper = Paper.new
#    @matchedPaper.title = params[:paper][:matchedPaper][:title]
#    @matchedPaper.archive = params[:paper][:matchedPaper][:archive]
#    @matchedPaper.source_id = params[:paper][:matchedPaper][:source_id]
#    @matchedPaper.pub_date = params[:paper][:matchedPaper][:pub_date]
#    @paper.matchedPaper = @matchedPaper
#    Author.find(params[:paper][:authors]).each do |author|
#      @paper.authors << author
#      @matchedPaper.authors << author
#    end

#    flash[:notice] = "Papers successfully added." if @paper.save

    @pairs = Author.find(params[:paper][:authors])
    @coauthors_names = @pairs.map{|author| author.name}.join(", ")
    @coauthors_ids = @pairs.map{|author| author.id}.join("_")
    @matches = (@pairs[0].papers & @pairs[1].papers).reject{|paper| paper.archive !~ /arXiv/}.map{|paper| paper.title + " => " + paper.matchedPaper.title }
    @arxiv_papers = JSON.parse(params[:paper][:arxiv].to_s)
    @elsevier_papers = JSON.parse(params[:paper][:elsevier].to_s)
#    matched_paper_id = params[:matchedPaper][:source_id]
    @matches << params[:paper][:title] + " => " + params[:paper][:matchedPaper][:title]
    @arxiv_papers.each_with_index do |a,i|
      if a['entry']['id'].match(params[:paper][:source_id])
        @arxiv_papers.slice!(i)
      end
    end
    @elsevier_papers.each_with_index do |els,i|
      if els['eid'].match(params[:paper][:matchedPaper][:source_id])
        @elsevier_papers.slice!(i)
      end
    end

#    <%= render :partial => "potC_pairs", :locals => {coauthors: @coauthors_string[i], matches: @matches[i]} %>
#    <%= render :partial => "potC_form", :locals => {arxiv: arxiv, elsevier_papers: @elsevier_papers[i], pairs: @pairs[i], index: i, coauthors: @coauthors_string[i] }%>
#    <%= render :partial => "potC_arxiv", :locals => {arxiv: arxiv, coauthors: @coauthors_string[i]} %>
#    <%= render :partial => "potC_elsevier", :locals => {elsevier_papers: @elsevier_papers[i], coauthors: @coauthors_string[i]} %>
#    $('tr.pairs[id="<%= @coauthors_names %>"]').append("<%= j render(:partial => 'papers/potC_pairs', :locals => {coauthors:@coauthors_names, matches:@matches}) %>");
#    $('tr.form[id="<%= @coauthors_names %>"]').append("<%= j render(:partial => 'papers/potC_form', :locals => {arxiv:@arxiv_papers, elsevier_papers: @elsevier_papers, pairs:@pairs, coauthors:@coauthors_names }) %>");
#    $('tr.papers[id="<%= @coauthors_names %>"]').append("<%= j render(:partial => 'papers/potC_arxiv', :locals => {arxiv:@arxiv_papers, coauthors:@coauthors_names }) %>");
#    $('tr.papers[id="<%= @coauthors_names %>"]').append("<%= j render(:partial => 'papers/potC_elsevier', :locals => {elsevier_papers: @elsevier_papers, coauthors:@coauthors_names }) %>");

#    @elsevier_query = "https://api.elsevier.com/content/search/scopus?insttoken=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&apiKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&query=au-id("+@pairs[0].elsevier_id+")+AND+au-id("+@pairs[1].elsevier_id+")"
#    begin
#      response = HTTParty.get(@elsevier_query)
#      @json = JSON.parse(response.body)
#      papers_array = (@pairs[0].papers & @pairs[1].papers).reject{|paper| paper.archive !~ /arXiv/}
#      @elsevier_papers = @json["search-results"]["entry"].reject{|paper| papers_array.map{|p| p.matchedPaper.title}.include? paper["dc:title"]}
#    rescue Exception => e  
#      @elsevier_papers = ["Exception occurred: " + e.to_s]
#    end

#    respond_to( render :nothing => true )
#    respond_with( @comment, :layout => !request.xhr? )

    respond_to do |format|
      format.js { render :file => "papers/create.js.erb" }
#      if @paper.save
#        format.html { redirect_to @paper, notice: 'Paper was successfully created.' }
#        format.json { render json: @paper, status: :created, location: @paper }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @paper.errors, status: :unprocessable_entity }
#      end
    end
  end

  # PUT /papers/1
  # PUT /papers/1.json
  def update
    @paper = Paper.find(params[:id])

    respond_to do |format|
      if @paper.update_attributes(params[:paper])
        format.html { redirect_to @paper, notice: 'Paper was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.json
  def destroy
    @paper = Paper.find(params[:id])
    @paper.destroy

    respond_to do |format|
      format.html { redirect_to papers_url }
      format.json { head :no_content }
    end
  end
end
