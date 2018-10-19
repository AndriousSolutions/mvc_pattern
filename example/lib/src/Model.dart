/// Note: This license has also been called the "Simplified BSD License" and the "FreeBSD License".
/// See also the 2-clause BSD License.
///
/// Copyright 2018 www.andrioussolutions.com
///
/// Redistribution and use in source and binary forms, with or without modification,
/// are permitted provided that the following conditions are met:
///
/// 1. Redistributions of source code must retain the above copyright notice,
/// this list of conditions and the following disclaimer.
///
/// 2. Redistributions in binary form must reproduce the above copyright notice,
/// this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
/// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
/// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
/// IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
/// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
/// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
/// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
/// Uncomment to try this example.
//import 'package:english_words/english_words.dart';

class Model {
  static final List<String> _suggestions = [];
  static int get length => _suggestions.length;

  static String wordPair(int index) {
    if (index == null || index < 0) index = 0;
    return _suggestions[index];
  }

  static bool contains(String pair) {
    if (pair == null || pair.isEmpty) return false;
    return _saved.contains(pair);
  }

  static final Set<String> _saved = Set();

  static void save(String pair) {
    if (pair == null || pair.isEmpty) return;
    final alreadySaved = contains(pair);
    if (alreadySaved) {
      _saved.remove(pair);
    } else {
      _saved.add(pair);
    }
  }

  static Iterable<ListTile> saved<ListTile>(Function f) => _saved.map(f);

  static Iterable<String> wordPairs([int count = 10]) => makeWordPairs(count);

  static void addAll(int count) {
    _suggestions.addAll(wordPairs(count));
  }
}

Iterable<String> makeWordPairs(int count) {
  /// Uncomment to try this example.
//  return generateWordPairs().take(count).map((pair){return pair.asPascalCase;});
}
