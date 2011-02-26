require'rexml/document'

module Douban

				class Subject
								class<<self
												def attr_names
																[
																				:id,
																				:title,
																				:category,
																				:author,
																				:link,
																				:summary,
																				:attribute,
																				:tag,
																				:rating
																]
												end
								end
								attr_names.each do |attr|
												attr_accessor attr
								end
								def initialize(atom='')
								       	doc=REXML::Document.new(atom)
												id=REXML::XPath.first(doc,"//id")
												@id=id.text if id
												title=REXML::XPath.first(doc,"//title")
												@title=title.text if title
												@category={}
												category=REXML::XPath.first(doc,"//category")
												@category['term']=category.attributes['term'] if category
												@category['scheme']=category.attributes['scheme'] if category
												REXML::XPath.each(doc,"//db:tag") do |tag|
																@tag||=[]
																t=Tag.new
																t.title=tag.attributes['name']
																t.count=tag.attributes['count']
																@tag<<t
												end
												@author||=Author.new
												name=REXML::XPath.first(doc,"//author/name")
												@author.name=name.text if name
												uri=REXML::XPath.first(doc,"//author/uri")
												@author.uri=uri.text if uri
												REXML::XPath.each(doc,"//author/link") do |link|
																@author.link||={}
																@author.link[link.attributes['rel']]=link.attributes['href']
												end
												summary=REXML::XPath.first(doc,"//summary")
												@summary=summary.text if summary
												REXML::XPath.each(doc,"//link") do |link|
																@link||={}
																@link[link.attributes['rel']]=link.attributes['href']
												end
												REXML::XPath.each(doc,"//attribute") do |attribute|
																@attribute||={}
																@attribute[attribute.attributes['name']]=attribute.text
												end
												@rating={}
												rating=REXML::XPath.first(doc,"//gd:rating")
												if rating
																@rating['min']=rating.attributes['min'] 
																@rating['numRaters']=rating.attributes['numRaters'] 
																@rating['average']=rating.attributes['average'] 
																@rating['max']=rating.attributes['max']
												end
								end
				end
				class Author
								class<<self
												def attr_names
																[
																				:uri,
																				:link,
																				:name
																]
												end
								end
								attr_names.each do |attr|
												attr_accessor attr
								end
								def initialize(entry="")
												doc=REXML::Document.new(entry)
												REXML::XPath.each(doc,"//link") do|link|
																@link||={}
																@link[link.attributes['rel']]=link.attributes['href']
												end
												name=REXML::XPath.first(doc,"//name")
												@name=name.text if name
												uri=REXML::XPath.first(doc,"//uri")
												@uri=uri.text if uri
								end
				end
				class Movie<Subject
								def initialize(atom)
												super(atom)
								end
				end
				class Book<Subject
								def initialize(atom)
								  atom = atom.to_s.gsub!('db:', '') ####ri,,,,,, 
								  atom = atom.to_s.gsub!('gd:', '') ####ri,,,,,,
									super(atom)
								end
				end
				class Music<Subject
								def initialize(atom)
												super(atom)
								end
				end


				class Tag
								include Douban
								class << self
												def attr_names
																[ 
																				:id,
																				:count,
																				:title 
																]
												end
								end
								attr_names.each do |attr|
												attr_accessor attr
								end

								def initialize(atom="")
												doc=REXML::Document.new(atom)
												id=REXML::XPath.first(doc,"//entry/id")
												@id=id.text if id
												title=REXML::XPath.first(doc,"//entry/title")
												@title=title.text if title
												count=REXML::XPath.first(doc,"//entry/db:count")
												@count=count.text if count
								end
				end


				class Review
								class <<self
												def attr_names
																[
																				:updated,
																				:subject,
																				:author,
																				:title,
																				:summary,
																				:link,
																				:id,
																				:rating
																]
												end
								end
								attr_names.each do |attr|
												attr_accessor attr
								end
								def initialize(atom)
								        atom = atom.to_s.gsub!('gd:', '') #when find all reviews of a subject
												doc=REXML::Document.new(atom)
												subject=REXML::XPath.first(doc,"//entry/db:subject")
												#remove db:, otherwise there is error 'Undefined prefix'
												@subject=Subject.new(subject.to_s.gsub!('db:', '')) if subject
												author=REXML::XPath.first(doc,"//entry/author")
												@author=Author.new(author.to_s) if author
												title=REXML::XPath.first(doc,"//entry/title")
												@title=title.text if title
												updated=REXML::XPath.first(doc,"//entry/updated")
												@updated=updated.text if updated
												summary=REXML::XPath.first(doc,"//entry/summary")
												@summary=summary.text if summary
												REXML::XPath.each(doc,"//entry/link") do |link|
																@link||={}
																@link[link.attributes['rel']]=link.attributes['href']
												end
												id=REXML::XPath.first(doc,"//entry/id")
												@id=id.text if id
												rating=REXML::XPath.first(doc,"//entry/db:rating")
												if rating
																@rating={}
																@rating['min']=rating.attributes['min']
																@rating['value']=rating.attributes['value']
																@rating['max']=rating.attributes['max']
												end
								end
				end
				
				class People
            class << self
              def attr_names
                [ 
                  :id,
                  :location,
                  :title,
                  :link,
                  :content,
                  :uid
                ]
              end
            end
            attr_names.each do |attr|
              attr_accessor attr
            end

            def initialize(atom)
              doc=REXML::Document.new(atom)
              id=REXML::XPath.first(doc,"//entry/id")
              @id=id.text if id
              content=REXML::XPath.first(doc,"//entry/content")
              @content=content.text if content
              title=REXML::XPath.first(doc,"//entry/title")
              @title=title.text if title
              location=REXML::XPath.first(doc,"//entry/db:location")
              @location=location.text if location
              uid=REXML::XPath.first(doc,"//entry/db:uid")
              @uid=uid.text if uid
              REXML::XPath.each(doc,"//entry/link") do|link|
                @link||={}
                @link[link.attributes['rel']]=link.attributes['href']
              end
            end
        end
        
				
        class Miniblog
          class <<self
            def attr_names
              [
               :id,
               :title,
               :category,
               :published,
               :link,
               :content,
               :attribute,
               :author
              ]
             end
           end
           attr_names.each do |attr|
             attr_accessor attr
           end
           def initialize(atom)
             atom = atom.to_s.gsub('db:', '') ####ri,,,,,,
             doc=REXML::Document.new(atom)
             title=REXML::XPath.first(doc,"//entry/title")
             @title=title.text if title
             published=REXML::XPath.first(doc,"//entry/published")
             @published=published.text if published
             REXML::XPath.each(doc,"//entry/link") do |link|
               @link||={}
               @link[link.attributes['rel']]=link.attributes['href']
             end
             id=REXML::XPath.first(doc,"//entry/id")
             @id=id.text if id
             REXML::XPath.each(doc,"//entry/db:attribute") do |attr|##############? db: is cleared, right?
               @attribute||={}
               @attribute[attr.attributes['name']]=attr.text
             end
             category=REXML::XPath.first(doc,"//entry/category")
             if category
               @category={}
               @category['term']=category.attributes['term']
               @category['scheme']=category.attributes['scheme']
             end
             content=REXML::XPath.first(doc,"//entry/content")
             @content=content.text if content
             author=REXML::XPath.first(doc,"//entry/author")
             @author=Author.new(author.to_s) if author
           end
        end
        
        class Bookmark
           class <<self
             def attr_names
               [
                :subject
               ]
              end
            end
            attr_names.each do |attr|
              attr_accessor attr
            end
            def initialize(atom)
              atom = atom.to_s.gsub('db:', '') ####ri,,,,,,
              doc=REXML::Document.new(atom)
              subject=REXML::XPath.first(doc,"//entry/subject")
							@subject=Subject.new(subject.to_s) if subject
						end
         end


end
