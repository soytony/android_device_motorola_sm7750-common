extern "C" const char* perf_get_prop(const char* name, const char* default_value);

extern "C" double get_perf_hal_ver() {
    // Keep the stock client in this library's dependency closure so its
    // remaining perf_* symbols satisfy libqti_performance.so directly.
    auto* volatile stock_client_anchor = &perf_get_prop;
    (void)stock_client_anchor;
    return 2.3;
}
