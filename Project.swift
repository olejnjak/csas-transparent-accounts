import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TransparentAccounts",
    targets: [
        app,
        core,
        transparentAccountsList, transparentAccountsListTests,
    ]
)
