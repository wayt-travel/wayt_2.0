

// TODO: example of a cubit test
// void main() {
//   group('CounterCubit', () {
//     test('initial state is 0', () {
//       expect(CounterCubit().state, equals(0));
//     });

//     blocTest<CounterCubit, int>(
//       'emits [1] when increment is called',
//       build: CounterCubit.new,
//       act: (cubit) => cubit.increment(),
//       expect: () => [equals(1)],
//     );

//     blocTest<CounterCubit, int>(
//       'emits [-1] when decrement is called',
//       build: CounterCubit.new,
//       act: (cubit) => cubit.decrement(),
//       expect: () => [equals(-1)],
//     );
//   });
// }