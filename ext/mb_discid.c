/*---------------------------------------------------------------------------
 $Id$
 Copyright (c) 2007, Philipp Wolfer
 All rights reserved.
 See LICENSE for permissions.

 Ruby bindings for libdiscid. See http://musicbrainz.org/doc/libdiscid
 for more information on libdiscid and MusicBrainz.
---------------------------------------------------------------------------*/

#include "ruby.h"
#include "discid/discid.h"

/**
 * The MusicBrainz module.
 */
static VALUE mMusicBrainz;

/**
 * The DiscID class.
 */
static VALUE cDiscID;

/**
 * Returns the DiscID as a string.
 * 
 * Returns nil if no ID was yet read.
 */
static VALUE mb_discid_id(VALUE self)
{
	if (rb_iv_get(self, "@read") == Qfalse)
		return Qnil;
	else
	{
		DiscId *disc;
		Data_Get_Struct(self, DiscId, disc);
		
		return rb_str_new2(discid_get_id(disc));
	}
}

/**
 * Returns a submission URL for the DiscID as a string.
 * 
 * Returns nil if no ID was yet read.
 */
static VALUE mb_discid_submission_url(VALUE self)
{
	if (rb_iv_get(self, "@read") == Qfalse)
		return Qnil;
	else
	{
		DiscId *disc;
		Data_Get_Struct(self, DiscId, disc);
		
		return rb_str_new2(discid_get_submission_url(disc));
	}
}

/**
 * Return a FreeDB DiscID as a string.
 * 
 * Returns nil if no ID was yet read.
 */
static VALUE mb_discid_freedb_id(VALUE self)
{
	if (rb_iv_get(self, "@read") == Qfalse)
		return Qnil;
	else
	{
		DiscId *disc;
		Data_Get_Struct(self, DiscId, disc);
		
		return rb_str_new2(discid_get_freedb_id(disc));
	}
}

/**
 * Return the number of the first track on this disc.
 * 
 * Returns nil if no ID was yet read.
 */
static VALUE mb_discid_first_track_num(VALUE self)
{
	if (rb_iv_get(self, "@read") == Qfalse)
		return Qnil;
	else
	{
		DiscId *disc;
		Data_Get_Struct(self, DiscId, disc);
		
		return INT2FIX(discid_get_first_track_num(disc));
	}
}

/**
 * Return the number of the last track on this disc.
 * 
 * Returns nil if no ID was yet read.
 */
static VALUE mb_discid_last_track_num(VALUE self)
{
	if (rb_iv_get(self, "@read") == Qfalse)
		return Qnil;
	else
	{
		DiscId *disc;
		Data_Get_Struct(self, DiscId, disc);
		
		return INT2FIX(discid_get_last_track_num(disc));
	}
}

/**
 * Return the length of the disc in sectors.
 * 
 * Returns nil if no ID was yet read.
 */
static VALUE mb_discid_sectors(VALUE self)
{
	if (rb_iv_get(self, "@read") == Qfalse)
		return Qnil;
	else
	{
		DiscId *disc;
		Data_Get_Struct(self, DiscId, disc);
		
		return INT2FIX(discid_get_sectors(disc));
	}
}

/**
 * Returns an array of [offset, length] tuples for each track.
 * 
 * If a block is given this method returns nil and instead iterates over the
 * block calling the block with two arguments |offset, length|.
 *
 * Returns always nil if no ID was yet read. The block won't be called in
 * this case.
 */
static VALUE mb_discid_tracks(VALUE self)
{
	if (rb_iv_get(self, "@read") == Qfalse)
		return Qnil;
	else
	{
		DiscId *disc;
		Data_Get_Struct(self, DiscId, disc);
		
		{ // Stupid MS compiler.
		
		VALUE result = rb_ary_new(); // Array of all [offset, length] tuples
		VALUE tuple; // Array to store one [offset, length] tuple.
		int track = discid_get_first_track_num(disc); // Track number
		while (track <= discid_get_last_track_num(disc))
		{
			tuple = rb_ary_new3(2,
				INT2FIX(discid_get_track_offset(disc, track)),
				INT2FIX(discid_get_track_length(disc, track)) );
			
		   	if (rb_block_given_p())
				rb_yield(tuple);
			else
				rb_ary_push(result, tuple);
				
			track++;
		}
		
		if (rb_block_given_p())
			return Qnil;
		else
			return result;
		
		} // Stupid MS compiler.
	}
}

/**
 * Read the disc ID from the given device.
 * 
 * If no device is given the default device of the platform will be used.
 */
static VALUE mb_discid_read(int argc, VALUE *argv, VALUE self)
{
	DiscId *disc;
	Data_Get_Struct(self, DiscId, disc);
	
	{ // Stupid MS compiler.
	
	VALUE device = Qnil; // The device string as a Ruby string.
	char* cdevice;       // The device string as a C string.
	
	// Check the number of arguments
	if (argc > 1)
		rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
	// Convert the given device to a T_STRING
	else if (argc > 0)	
		device = rb_funcall(argv[0], rb_intern("to_s"), 0, 0);
	
	// Use the default device if none was given.
	if (argc < 1 || RSTRING(device)->len == 0)
		cdevice = discid_get_default_device();
	else
		cdevice = STR2CSTR(device);
	
	// Mark the disc id as unread in case something goes wrong.
	rb_iv_set(self, "@read", Qfalse);
	
	// Read the discid
	if (discid_read(disc, cdevice) == 0)
		rb_raise(rb_eException, discid_get_error_msg(disc));
	else // Remember that we already read the ID.
		rb_iv_set(self, "@read", Qtrue);
	
	return Qnil;
	
	} // Stupid MS compiler.
}

/**
 * Construct a new DiscID object.
 * 
 * As an optional argument the name of the device to read the ID from
 * may be given. If you don't specify a device here you can later read
 * the ID with the read method.
 */
VALUE mb_discid_new(int argc, VALUE *argv, VALUE class)
{
	DiscId *disc = discid_new();
	VALUE tdata = Data_Wrap_Struct(class, 0, discid_free, disc);
	rb_obj_call_init(tdata, 0, 0);
	rb_iv_set(tdata, "@read", Qfalse);
	
	// Check the number of arguments
	if (argc > 1)
		rb_raise(rb_eArgError, "wrong number of arguments (%d for 1)", argc);
	// If a device was given try to read the disc id from this device.
	else if (argc > 0)
		rb_funcall(tdata, rb_intern("read"), 1, argv[0]);
	
	return tdata;
}

/**
 * Returns a device string for the default device for this platform.
 */
VALUE mb_discid_default_device(VALUE class)
{
	return rb_str_new2(discid_get_default_device());
}

/**
 * Initialize the DiscID class and make it available in Ruby.
 */
void Init_MB_DiscID()
{
	mMusicBrainz = rb_define_module("MusicBrainz");
  	cDiscID = rb_define_class_under(mMusicBrainz, "DiscID", rb_cObject);
	rb_define_singleton_method(cDiscID, "new", mb_discid_new, -1);
	rb_define_singleton_method(cDiscID, "default_device",
	                           mb_discid_default_device, 0);
	
  	rb_define_method(cDiscID, "read", mb_discid_read, -1);
  	rb_define_method(cDiscID, "id", mb_discid_id, 0);
  	rb_define_method(cDiscID, "submission_url", mb_discid_submission_url, 0);
  	rb_define_method(cDiscID, "freedb_id", mb_discid_freedb_id, 0);
  	rb_define_method(cDiscID, "first_track_num", mb_discid_first_track_num, 0);
  	rb_define_method(cDiscID, "last_track_num", mb_discid_last_track_num, 0);
  	rb_define_method(cDiscID, "sectors", mb_discid_sectors, 0);
  	rb_define_method(cDiscID, "tracks", mb_discid_tracks, 0);
}
