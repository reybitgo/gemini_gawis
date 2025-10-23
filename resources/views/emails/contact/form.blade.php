<x-mail::message>
# New Contact Form Submission

You have received a new message from your website's contact form.

**First Name:** {{ $data['fname'] }}
**Last Name:** {{ $data['lname'] }}
**Email:** {{ $data['email'] }}
**Phone:** {{ $data['phone'] }}

**Message:**
{{ $data['message'] }}

Thanks,<br>
{{ config('app.name') }}
</x-mail::message>
