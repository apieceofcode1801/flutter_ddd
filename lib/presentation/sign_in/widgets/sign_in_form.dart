import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignInFormBloc>();
    return BlocConsumer<SignInFormBloc, SignInFormState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: ListView(
              children: [
                const Text(
                  '📔',
                  style: TextStyle(fontSize: 130),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    autocorrect: false,
                    onChanged: (value) =>
                        bloc.add(SignInFormEvent.emailChanged(emailStr: value)),
                    validator: (_) => bloc.state.emailAddress.value.fold(
                        (f) => f.maybeMap(
                            invalidEmail: (_) => 'Invalid Email',
                            orElse: () => null),
                        (_) => null)),
                const SizedBox(height: 8),
                TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    onChanged: (value) => bloc.add(
                        SignInFormEvent.passwordChanged(passwordStr: value)),
                    validator: (_) => bloc.state.password.value.fold(
                        (f) => f.maybeMap(
                            shortPassword: (_) => 'Short Password',
                            orElse: () => null),
                        (_) => null)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              bloc.add(const SignInFormEvent
                                  .signInWithEmailAndPasswordPressed());
                            },
                            child: const Text('SIGN IN'))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              bloc.add(const SignInFormEvent
                                  .registerWithEmailAndPasswordPressed());
                            },
                            child: const Text('REGISTER')))
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                    onPressed: () {
                      bloc.add(const SignInFormEvent.signInWithGooglePressed());
                    },
                    child: const Text(
                      'SIGN IN WITH GOOGLE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                if (state.isSubmitting) ...[
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(
                    value: null,
                  )
                ]
              ],
            )),
      );
    }, listener: (context, state) {
      state.authFailureOrSuccess.fold(
          () => null,
          (either) => either.fold((failure) {
                final snackBar = SnackBar(
                    content: Text(failure.map(
                        cancelByUser: (_) => 'Cancelled!',
                        serverError: (_) => 'Server Error',
                        emailAlreadyInUse: (_) =>
                            'Email address already in use',
                        invalidEmailAndPasswordCombination: (_) =>
                            'Invalid email and password combination')));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }, (_) {}));
    });
  }
}
