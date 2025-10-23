<?php

namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\Http;

use Illuminate\Support\Facades\Log;



class ContactController extends Controller

{

    public function submit(Request $request)

    {

        $request->validate([

            'fname' => 'required',

            'lname' => 'required',

            'email' => 'required|email',

            'phone' => 'required',

            'message' => 'required',

        ]);



        $data = $request->all();



        $message = "You have a new contact form submission:\n\n" .

                   "First Name: " . $data['fname'] . "\n" .

                   "Last Name: " . $data['lname'] . "\n" .

                   "Email: " . $data['email'] . "\n" .

                   "Phone: " . $data['phone'] . "\n" .

                   "Message: " . $data['message'];



        try {

            $response = Http::asForm()->post('https://formsubmit.co/support@gawisherbal.com', [

                '_subject' => 'New Contact Form Submission from ' . $data['fname'] . ' ' . $data['lname'],

                'email' => $data['email'],

                'message' => $message,

            ]);



            if ($response->successful()) {

                return back()->with('success', 'Thank you for your message. It has been sent.');

            } else {

                Log::error('FormSubmit.co request failed', ['status' => $response->status(), 'body' => $response->body()]);

                return back()->with('error', 'We were unable to send your message at this time. Please try again later.')->withInput();

            }

        } catch (\Exception $e) {

            Log::error('FormSubmit.co request failed with exception: ' . $e->getMessage());

            return back()->with('error', 'We were unable to send your message at this time. Please try again later.')->withInput();

        }

    }

}
