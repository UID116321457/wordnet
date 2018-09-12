require_relative "graph.rb"
#!/usr/bin/env ruby
#
class Synsets
    def initialize
      @synset = Hash.new
    end


    def load(synsets_file)
        invalidArray = Array.new
        validArray = Array.new


        fileIsValid = true
        counter = 0

        synsetfile = File.new(synsets_file, "r")
        synsetfile.each_line do |line|
        if line[0..3] == "id: " && line[4].to_i == counter && line[5..12] == " synset:"
            validArray.push(line)
        else
          fileIsValid = false
          invalidArray.push(counter+1)
        end
        counter +=1
      end
      if fileIsValid
        synsetfile = File.new(synsets_file, "r")
        synsetfile.each_line do |line|
        addSet(line[4].to_i,line[14..line.size-2].split(','))
        end
        nil
      else
        invalidArray
      end

    end

    def addSet(synset_id, nouns)
        if synset_id < 0 || (nouns.empty?) || @synset.key?(synset_id)
          false
        else
          @synset[synset_id] = nouns
          true
        end
    end

    def lookup(synset_id)
      if !@synset.key?(synset_id)
        []
      else
        @synset[synset_id]
      end
    end

    def findSynsets(to_find)
      if to_find.is_a? String
        arr = Array.new
        @synset.each do |key,value|
          if value.include?(to_find)
            arr.push(key)
          end
        end
        arr
      elsif to_find.is_a? Array
        hash = Hash.new
        to_find.each do |x|
          tempArr = Array.new
          @synset.each do |key,value|
            if value.include?(x)
              tempArr.push(key)
            end
          end
        hash[x] = tempArr
        end
      hash
      else
        nil
      end
    end
end


class Hypernyms
    def initialize
      @graph = Graph.new
    end

    def load(hypernyms_file)
      counter = 0

      invalidArray = Array.new
      validArray = Array.new

      fileIsValid = true

      hypernymsfile = File.new(hypernyms_file, "r")
      hypernymsfile.each do |x|


        if x[0..5] == "from: " && x[7..11] == " to: " && (x[6].is_a? Integer)
          validArray.push(x)
        else
        fileIsValid = false
        invalidArray.push(counter+1)
        end
      counter +=1
    end
      if fileIsValid
        hf = File.new(hypernyms_file, "r")
        hf.each_line do |x|
          to = x[12..x.size-2].split(',')
          if !@graph.hasVertex?(x[6].to_i)
            @graph.addVertex(x[6].to_i)
          end
          to.each do |dest|
          if !@graph.hasVertex?(dest.to_i)
          #  puts(dest)
            @graph.addVertex(dest.to_i)
          end
        end
            to.each do |dest|
            addHypernym(x[6].to_i,dest.to_i)
        end

      end
        nil
      else
        invalidArray
      end
    end

    def addHypernym(source, destination)
        if source == destination || source < 0 || destination < 0
          false
        else
          @graph.addEdge(source, destination)
          true
        end
    end

    def lca(id1, id2)
        raise Exception, "Not implemented"
    end
end

class What
  #word = Synsets.new
  #word.load("inputs/public_synsets_valid")

  what = Hypernyms.new
  puts(what.load("inputs/public_hypernyms_valid"))
  #what.load("inputs/public_hypernyms_invalid")

  #print("test")
  #print(word.lookup(0))
#  print(word.findSynsets(["b","a"]))
end

class CommandParser
    def initialize
        @synsets = Synsets.new
        @hypernyms = Hypernyms.new
    end

    def parse(command)
        raise Exception, "Not implemented"
    end
end
