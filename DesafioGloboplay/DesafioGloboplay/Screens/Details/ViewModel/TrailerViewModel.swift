//
//  TrailerViewModel.swift
//  DesafioGloboplay
//
//  Created by Thalles Araújo on 31/07/23.
//

import SwiftUI
class TrailerViewModel: ViewModel, ObservableObject{
    
    @Published var trailer: TrailerResult?
    
    func getTrailerResult(movieId: Int){
        do{
            perform(TrailerResults.self, request: try APIURLs.getMovieVideos(movieId).request()) { videos in
                self.trailer = videos.results?.first(where: {$0.type == .trailer})
            }
        }
        catch {
            errorProcedure()
        }
    }
    
    
}
