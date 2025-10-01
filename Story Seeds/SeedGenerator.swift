//
//  SeedGenerator.swift
//  Story Seeds
//
//  Core generation logic for words and phrases
//

import Foundation

// MARK: - Seed Generator Service

class SeedGenerator: ObservableObject {
    
    // MARK: - Configuration
    private let wordsPerGeneration = 3
    private let phrasesPerGeneration = 2
    
    // MARK: - Generation Methods
    
    func generateSeeds(for category: SeedCategory) -> SeedItem {
        let contents: [String]
        
        switch category {
        case .words:
            contents = generateWords()
        case .phrases:
            contents = generatePhrases()
        case .mixed:
            contents = generateMixed()
        }
        
        return SeedItem(category: category, contents: contents)
    }
    
    // MARK: - Private Generation Methods
    
    private func generateWords() -> [String] {
        return Array(SeedData.words.shuffled().prefix(wordsPerGeneration))
    }
    
    private func generatePhrases() -> [String] {
        return Array(SeedData.phrases.shuffled().prefix(phrasesPerGeneration))
    }
    
    private func generateMixed() -> [String] {
        let words = generateWords()
        let phrases = generatePhrases()
        return (words + phrases).shuffled()
    }
}
