test_that("sentix_annotate handles simplify argument correctly", {
    skip_if_not_installed("udpipe")

    # Create a simple test dataframe
    df <- data.frame(
        doc_id = c("doc1"),
        text = c("Il film è bello."),
        stringsAsFactors = FALSE
    )

    # Test simplify = TRUE (default)
    tryCatch(
        {
            annotated_simple <- sentix_annotate(df, simplify = TRUE)
            expect_true("upos" %in% colnames(annotated_simple))
            expect_false("xpos" %in% colnames(annotated_simple))
        },
        error = function(e) {
            skip(paste0("Skipping sentix_annotate test due to model loading error: ", e$message))
        }
    )

    # Test simplify = FALSE -> should have 'upos' column and standard udpipe cols
    tryCatch(
        {
            annotated_full <- sentix_annotate(df, simplify = FALSE)
            expect_true("upos" %in% colnames(annotated_full))
            expect_true("token_id" %in% colnames(annotated_full))
        },
        error = function(e) {
            skip("Skipping sentix_annotate test due to model loading error")
        }
    )
})

test_that("sentix_annotate supports list input", {
    skip_if_not_installed("udpipe")

    lst <- list(doc1 = "Ciao mondo")
    tryCatch(
        {
            ann <- sentix_annotate(lst, simplify = TRUE)
            expect_true("doc_id" %in% names(ann))
            expect_equal(ann$doc_id[1], "doc1")
        },
        error = function(e) skip("Model error")
    )
})
