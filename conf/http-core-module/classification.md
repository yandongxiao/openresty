# directives

# **接受请求**

1. merge_slashes
1. ignore_invalid_headers
1. underscores_in_headers
1. client_header_buffer_size
1. client_header_timeout
1. large_client_header_buffers
1. max_ranges
1. client_body_buffer_size
1. client_body_temp_path
1. client_max_body_size
1.  **client_body_in_single_buffer** 
1. client_body_timeout

# **处理请求**

1. server
1. listen-->reuseport
1. server_name
1. location
1. limit_except
1. internal
1. alias
1. root
1. satisfy
1. disable_symlinks
1. index
1. try_files
1. error_page
1. recursive_error_pages
1. open_file_cache
1. open_file_cache_valid
1. open_file_cache_errors
1. open_file_cache_min_uses
1. resolver
1. resolver_timeout
1. log_not_found
1. log_subrequest
1. lingering_close
1. lingering_timeout
1. lingering_time

# **生成响应**

1. tcp_nodelay
1. tcp_nopush
1. http1.1-->keepalive
1. output_buffers
1. postpone_output
1. default_type
1. types
1. hash_bucket_size
1. hash_max_size
1. server_tokens
1. etag
1. if_modified_since
1. chunked_transfer_encoding
1. keepalive_requests
1. keepalive_timeout
1. server_name_in_redirect
1. port_in_redirect
1. limit_rate
1. limit_rate_after
1. send_lowat
1. send_timeout