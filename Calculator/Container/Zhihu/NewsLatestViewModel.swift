//
// Created by heyongjian on 2018/5/17.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Differentiator

class NewsLatestViewModel: ViewModelType {
    private let disposeBag: DisposeBag = DisposeBag()
    private let navigator: NewsLatestNavigatorProtocol

    init(navigator: NewsLatestNavigatorProtocol) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {

        let outputNewsList = input.buttonTitle.asDriver().flatMap { [weak self] (Void) -> Driver<[NewsLatestSection]> in
            return self!.getNewsList().asDriver(onErrorJustReturn: [])
        }

        return Output(newsList: outputNewsList)
    }

    private func getNewsList() -> Single<[NewsLatestSection]> {
        return APIProvider.rx.request(.getNewsLatest)
                .mapToObject(type: NewsLatest.self)
                .map({ (news) -> [NewsLatestSection] in
                    var newsSection = NewsLatestSection(header: "NewsLatest", items: [])
                    news.stories.forEach({ (info) in
                        newsSection.items.append(info.title)
                    })
                    return [newsSection]
                })
    }

}


extension NewsLatestViewModel {
    struct Input {
        let buttonTitle: Driver<Void>
    }

    struct Output {
        let newsList: Driver<[NewsLatestSection]>
    }
}
