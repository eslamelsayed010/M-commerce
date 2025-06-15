//
//  CategeoryViemModels.swift
//  M-commerce-App
//
//  Created by Macos on 14/06/2025.
//

import Foundation
class MenProductViewModel: BaseProductViewModel {
    override var categoryKeyword: String { "Men" }
}

class WomenProductViewModel: BaseProductViewModel {
    override var categoryKeyword: String { "Women" }
}

class KidsProductViewModel: BaseProductViewModel {
    override var categoryKeyword: String { "Kids" }
}

class SaleProductViewModel: BaseProductViewModel {
    override var categoryKeyword: String { "Sale" }
}
