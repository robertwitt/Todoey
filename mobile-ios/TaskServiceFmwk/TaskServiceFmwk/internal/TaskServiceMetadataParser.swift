// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

internal enum TaskServiceMetadataParser {
    internal static let options: Int = (CSDLOption.allowCaseConflicts | CSDLOption.disableFacetWarnings | CSDLOption.disableNameValidation | CSDLOption.processMixedVersions | CSDLOption.synthesizeTargetSets | CSDLOption.ignoreUndefinedTerms)

    internal static let parsed: CSDLDocument = xs_immortalize(TaskServiceMetadataParser.parse())

    static func parse() -> CSDLDocument {
        let parser = CSDLParser()
        parser.logWarnings = false
        parser.csdlOptions = TaskServiceMetadataParser.options
        let metadata = parser.parseInProxy(TaskServiceMetadataText.xml, url: "TaskAPI")
        metadata.proxyVersion = "22.9.4"
        return metadata
    }
}
