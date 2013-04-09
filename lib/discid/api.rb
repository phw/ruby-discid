require "ffi"

module DiscId
  module Api
    extend FFI::Library
    ffi_lib %w[discid, libdiscid.so.0]

    attach_function :new, :discid_new, [], :pointer

    attach_function :free, :discid_free, [:pointer], :void
  
    # TODO: Handle old discid_read
    attach_function :read, :discid_read_sparse, [:pointer, :string, :uint], :int

    # TODD: discid_put

    attach_function :get_error_msg, :discid_get_error_msg, [:pointer], :string
    
    attach_function :get_id, :discid_get_id, [:pointer], :string

    attach_function :get_freedb_id, :discid_get_freedb_id, [:pointer], :string

    attach_function :get_submission_url, :discid_get_submission_url, [:pointer], :string
    
    # TODO: webservice_url

    attach_function :default_device, :discid_get_default_device, [], :string

    attach_function :get_first_track_num, :discid_get_first_track_num, [:pointer], :int

    attach_function :get_last_track_num, :discid_get_last_track_num, [:pointer], :int

    attach_function :get_sectors, :discid_get_sectors, [:pointer], :int

    attach_function :get_track_offset, :discid_get_track_offset, [:pointer, :int], :int

    attach_function :get_track_length, :discid_get_track_length, [:pointer, :int], :int

    attach_function :get_mcn, :discid_get_mcn, [:pointer], :string

    attach_function :get_track_isrc, :discid_get_track_isrc, [:pointer, :int], :string

    enum :feature, [:read, 1 << 0,
                    :mcn, 1 << 1,
                    :isrc, 1 << 2]

    attach_function :has_feature, :discid_has_feature, [:feature], :int

    # TODO: discid_get_feature_list
    # TODO: discid_get_version_string
  end
end
