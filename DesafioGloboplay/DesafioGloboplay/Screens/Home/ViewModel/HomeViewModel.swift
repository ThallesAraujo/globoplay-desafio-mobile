//
//  HomeViewModel.swift
//  DesafioGloboplay
//
//  Created by Thalles Araújo on 26/07/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject{
    
    @Published var movieList: MoviesResults?
    @Published var tvShowsList: TVShowsResults?
    
    @Published var showError: Bool = false
    
    @Published var isLoading: Bool = false
    
    var completion: (() -> Void)?
    
    
    func getMovieList(){
        do{
            perform(MoviesResults.self, request: try APIURLs.getMovies.request()) { movies in
                self.movieList = movies
            }
        }
        catch {
            errorProcedure()
        }
    }
    
    
    func getTVShowsList(){
        do{
            perform(TVShowsResults.self, request: try APIURLs.getTVShows.request()) { shows in
                self.tvShowsList = shows
            }
        }
        catch {
            errorProcedure()
        }
    }
    
    private func errorProcedure(){
        self.showError = true
        self.isLoading = false
        if let completion = self.completion {completion()}
    }
    
    private func perform<T:Decodable>(_ type: T.Type, request: URLRequest, successCompletion: @escaping (T) -> Void){
        isLoading = true
        
        guard NetworkTester().isConnected() else {
            self.isLoading = false
            self.showError = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            if (error != nil) {
                print("Error")
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("Response:")
                print(httpResponse)
            }
            
            if let dataUnwrapped = data {
                
                if let result = try? JSONDecoder().decode(type.self, from: dataUnwrapped) {
                    DispatchQueue.main.async {
                        self.showError = false
                        successCompletion(result)
                        self.isLoading = false
                        if let completion = self.completion {completion()}
                    }
                    print("Resposta: ")
                    dump(result)
                } else {
                    print("JSON Inválido")
                    DispatchQueue.main.async {
                        self.errorProcedure()
                    }
                }
            }
            
        }.resume()
        
        
    }
    
}
