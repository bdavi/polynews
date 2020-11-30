# frozen_string_literal: true

module NLP
  module Operations
    class SentenceTokenizer < Pipeline::RecursiveOperation
      # Sentence tokenization is tricky. This regex isn't perfect, but it handles
      # most English language cases and is sufficent for our purpose.
      #
      # (?<![A-Z][a-z]\.) Not preceeded by upper then lower. Handle 'Dr. Smith' or 'Ms. Jones'
      # (?<!\w\.\w)       Not preceeded by letter-period-letter. As in an acronym like U.S.A
      # (?<! *\. *)       Not preceeded by a period or <space>-period (handle ellipses)
      # (?<=[?!.])        Preceeded by end of sentence punctuation
      # \s+               One or more space characters
      # (?=[A-Z])         Followed by a capital letter
      SENTENCE_BREAK_PATTERN = /(?<![A-Z][a-z]\.)(?<!\w\.\w)(?<=[?!.])\s+(?=[A-Z])/.freeze

      def self.tokenize(string)
        string.split(SENTENCE_BREAK_PATTERN).map(&:strip)
      end

      def self.operation
        method(:tokenize)
      end
    end
  end
end
