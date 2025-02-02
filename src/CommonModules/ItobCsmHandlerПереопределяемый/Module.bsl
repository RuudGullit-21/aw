////////////////////////////////////////////////////////////////////////////////
// В модуле описаны переопределяемые функции, если библиотека CsmHandler не подключилась.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает версию библиотеки CsmHandler.
//
// Параметры:
//  ТекстОшибки				 - Строка		 - Текст ошибки.
//  ДополнительныеПараметры	 - Произвольный	 - Дополнительные параметры, для работы с переопределяемым модулем, 
//		в случае ошибки в библиотеке.
// 
// Возвращаемое значение:
//  Строка - Версия библиотеки CsmHandler.
//
Функция Версия(ТекстОшибки = "", ДополнительныеПараметры = Неопределено) Экспорт
	Возврат "0.0.0";
КонецФункции
 
// Рассчитывает расстояние между точками по географическим координатам.
//
// Параметры:
//  Широта1					 - Число		 - Широта первой дочки.
//  Широта2					 - Число		 - Широта второй дочки.
//  Долгота1				 - Число		 - Долгота первой дочки.
//  Долгота2				 - Число		 - Долгота второй дочки.
//  ТекстОшибки				 - Строка		 - Текст ошибки.
//  ДополнительныеПараметры	 - Произвольный	 - Дополнительные параметры, для работы с переопределяемым модулем, 
//		в случае ошибки в библиотеке.
// 
// Возвращаемое значение:
//  Число - Расстояние между точками.
//
Функция Расстояние(Широта1, Широта2, Долгота1, Долгота2, ТекстОшибки = "", ДополнительныеПараметры = Неопределено) Экспорт
		
	Если Широта1 = Широта2 И Долгота1 = Долгота2 Тогда
		Возврат 0;
	
	КонецЕсли;
	
	Если Широта1 = Неопределено
		 Или Широта2 = Неопределено
		 Или Долгота1 = Неопределено
		 Или Долгота2 = Неопределено Тогда
		Возврат 0;
	
	КонецЕсли;
	
	// Константы, используемые для вычисления смещения и расстояния
	Pi=3.1415926535897932;
	D2R = Pi/180; // Константа для преобразования градусов в радианы
	R2D = 180/Pi; // Константа для преобразования радиан в градусы
	pa = 6378137.0; // Основные полуоси
	pb = 6356752.314245; // Неосновные полуоси
	e2 = 0.006739496742337; // Квадрат эксцентричности эллипсоида
	pf = 0.003352810664747; // Выравнивание эллипсоида
	
	// Вычисляем разницу между двумя долготами и широтами и получаем среднюю широту
	fdLambda = (Долгота1 - Долгота2) * D2R;
	fdPhi = (Широта1 - Широта2) * D2R;
	fPhimean = ((Широта1 + Широта2) / 2.0) * D2R;
	
	// Вычисляем меридианные и поперечные радиусы кривизны средней широты
	fTemp = 1 - e2 * (Pow(Sin(fPhimean), 2));
	fRho = (pa * (1 - e2)) / Pow(fTemp, 1.5);
	fNu = pa / (Sqrt(fTemp));
	
	// Вычисляем угловое расстояние
	fz = Sqrt(Pow(Sin(fdPhi / 2.0), 2) + Cos(Широта2 * D2R) * Cos(Широта1 * D2R) * Pow(Sin(fdLambda / 2.0), 2));
	
	fz = 2 * ASin(fz);
	
	// Вычисляем смещение
	fAlpha = Окр(Cos(Широта2 * D2R) * Sin(fdLambda) / Sin(fz),12);
	fAlpha = ?(fAlpha < 1,fAlpha,1);
	fAlpha = ASin(?(fAlpha > -1, fAlpha, -1));
	
	// Вычисляем радиус Земли
	fR = (fRho * fNu) / ((fRho * Pow(Sin(fAlpha), 2)) + (fNu * Pow(Cos(fAlpha), 2)));
	
	// Получаем смещение и расстояние
	Distance = (fz * fR);
		
	Возврат Distance;

КонецФункции
 
// Преобразует закодированные данные в коды датчиков и их значения.
//
// Параметры:
//  ДанныеДатчиков			 - Строка		 - Закодированные данные датчиков.
//  ВерсияФормата			 - Число		 - Версия формата данных.
//  ТекстОшибки				 - Строка		 - Текст ошибки.
//  ДополнительныеПараметры	 - Произвольный	 - Дополнительные параметры, для работы с переопределяемым модулем, 
//		в случае ошибки в библиотеке.
// 
// Возвращаемое значение:
//  Соответствие - Данные датчиков.
//
Функция СтрокаДляДанныхДатчика(ДанныеДатчиков, ВерсияФормата, ТекстОшибки = "", ДополнительныеПараметры = Неопределено) Экспорт

	Результат = Новый Соответствие;
	
	ДанныеДатчиковСтрока = СокрЛП(ДанныеДатчиков);
	
	КоличествоДатчиков = ?(ДанныеДатчиковСтрока="", 0, HexData2Dec(Лев(ДанныеДатчиковСтрока,2)));
	ДанныеДатчиковСтрока = Сред(ДанныеДатчиковСтрока,3);		
	
	Для Счетчик = 1 По КоличествоДатчиков Цикл
		
		Если ДанныеДатчиковСтрока="" Тогда
			Прервать;
		
		КонецЕсли;
		
		ЗначениеОтрицательное = Ложь;
		
		КодДатчика = HexData2Dec(Лев(ДанныеДатчиковСтрока,2));		
		ДанныеДатчиковСтрока = Сред(ДанныеДатчиковСтрока,3);
		
		ЧислоБайтЗначение = HexData2Dec(Лев(ДанныеДатчиковСтрока,2));		
		ДанныеДатчиковСтрока = Сред(ДанныеДатчиковСтрока,3);
		
		Если ВерсияФормата=2 Тогда
			// Первый байт - знак значения
			ТекЗнак = HexData2Dec(Лев(ДанныеДатчиковСтрока,2));		
			ДанныеДатчиковСтрока = Сред(ДанныеДатчиковСтрока,3);
			ЧислоБайтЗначение = ЧислоБайтЗначение-1;
			ЗначениеОтрицательное = НЕ ТекЗнак=0;
		КонецЕсли;
		
		ЗначениеДатчика = HexData2Dec(Лев(ДанныеДатчиковСтрока,2*ЧислоБайтЗначение));		
		ДанныеДатчиковСтрока = Сред(ДанныеДатчиковСтрока,2*ЧислоБайтЗначение+1);
		
		Результат.Вставить(КодДатчика, ЗначениеДатчика);
						
	КонецЦикла;
	
	Возврат Результат;	
	
КонецФункции
 
// Рассчитывает расстояния между точками.
//
// Параметры:
//  Координаты				 - Массив		 - Массив массивов координат.
//  ТекстОшибки				 - Строка		 - Текст ошибки.
//  ДополнительныеПараметры	 - Произвольный	 - Дополнительные параметры, для работы с переопределяемым модулем, 
//		в случае ошибки в библиотеке.
// 
// Возвращаемое значение:
//  Массив - Массив расстояний.
//
Функция МассивРасстояний(Координаты, ТекстОшибки = "", ДополнительныеПараметры = Неопределено) Экспорт
	Широты = Координаты[0];
	Долготы = Координаты[1];
	ПредШирота = 0;
	ПредДолгота = 0;
	Расстояния = Новый Массив();
	
	Для Счетчик = 0 По Широты.Количество() - 1 Цикл
		Если Счетчик > 0 Тогда
			Расстояния.Добавить(Расстояние(ПредШирота, Широты[Счетчик], ПредДолгота, Долготы[Счетчик]));
		КонецЕсли; 
		
		ПредШирота  = Широты[Счетчик];
		ПредДолгота = Долготы[Счетчик];				
	КонецЦикла; 
	
	Возврат Расстояния;
КонецФункции
 
// Преобразует закодированную полилинию из формата ломанной линии предоставленного гугл сервисом.
//
// Параметры:
//  ЗакодированнаяПолилиния	 - Строка		 - Закодированная полилиния.
//  ТекстОшибки				 - Строка		 - Текст ошибки.
//  ДополнительныеПараметры	 - Произвольный	 - Дополнительные параметры, для работы с переопределяемым модулем, 
//		в случае ошибки в библиотеке.
// 
// Возвращаемое значение:
//  Массив - Массив их двух элементов, массив с широтами и массив с долготами.
//
Функция РаскодированиеЛинии(ЗакодированнаяПолилиния, ТекстОшибки = "", ДополнительныеПараметры = Неопределено) Экспорт
		
	Возврат ДекодироватьПолилинию(ЗакодированнаяПолилиния);
	
КонецФункции
 
// Ищет значения датчиков в закодированных данных датчиков.
//
// Параметры:
//  ДанныеДатчиков			 - Массив		 - Массив из строк закодированных данных датчиков.
//  КодыДатчиков			 - Массив		 - Массив из кодов датчиков, которые нужно получить.
//  ВерсииФормата			 - Массив		 - Массив из версий форматов, элементов в массиве столько же сколько и в ДанныеДатчиков.
//  ТекстОшибки				 - Строка		 - Текст ошибки.
//  ДополнительныеПараметры	 - Произвольный	 - Дополнительные параметры, для работы с переопределяемым модулем, 
//		в случае ошибки в библиотеке.
// 
// Возвращаемое значение:
//  Массив - Массив массивов,
//  0 элемент массива - массив значений для кода датчика КодыДатчиков[0],
//  и т.п. до КодыДатчиков[КодыДатчиков.Количество() - 1].
//
Функция ПоискЗначенийДатчиков(ДанныеДатчиков, КодыДатчиков, ВерсииФормата, ТекстОшибки = "", ДополнительныеПараметры = Неопределено) Экспорт
	
	// Инициализация переменных.
	КодыДатчиковКоличество = КодыДатчиков.Количество() - 1;
	Результат = Новый Массив();
	
	// Если список кодов датчиков отсутствует, то лишний раз не напрягаемся.
	Если -1 < КодыДатчиковКоличество Тогда
		
		// Создаем массив результатов.
		Для СчетчикДатчиков = 0 По КодыДатчиковКоличество Цикл
		    Результат.Добавить(Новый Массив());
		КонецЦикла; 
		
		// Перебираем все значения датчиков.
		Для Счетчик = 0 По ДанныеДатчиков.Количество() - 1 Цикл
			СтруктураДанныеДатчиков = СтрокаДляДанныхДатчика(ДанныеДатчиков[Счетчик], ВерсииФормата[Счетчик], ТекстОшибки, ДополнительныеПараметры);
			
			// Добавляем в результаты полученные данные по датчикам.
			Для СчетчикДатчиков = 0 По КодыДатчиковКоличество Цикл
				
				// Получаем значение.
				Значение = СтруктураДанныеДатчиков.Получить(КодыДатчиков[СчетчикДатчиков]);
				
				// Проверяем значение, если пустое, то не добавляем.
				Если Не Значение = Неопределено Тогда
			    	Результат[СчетчикДатчиков].Добавить(Значение);
				КонецЕсли; 
			КонецЦикла; 
			
		КонецЦикла; 
		
	КонецЕсли;

	Возврат Результат;
КонецФункции
 
// Ищет значения датчиков в закодированных данных датчиков (включая виртуальные).
//
// Параметры:
//  ДанныеДатчиков				 - Массив	 - Массив из строк закодированных данных датчиков.
//  ДанныеВиртуальныхДатчиков	 - Массив	 - Массив из строк закодированных данных датчиков, 
//		элементов в массиве столько же сколько и в ДанныеДатчиков.
//  КодыДатчиков				 - Массив	 - Массив из кодов датчиков, которые нужно получить.
//  ВерсииФормата				 - Массив	 - Массив из версий форматов, элементов в массиве столько же сколько и в ДанныеДатчиков.
//  ТекстОшибки					 - Строка	 - Текст ошибки.
//  ДополнительныеПараметры		 - Произвольный	 - Дополнительные параметры, для работы с переопределяемым модулем, 
//		в случае ошибки в библиотеке.
// 
// Возвращаемое значение:
//  Массив - Массив массивов,
//  	0 элемент массива - массив значений для кода датчика КодыДатчиков[0],
//  	и т.п. до КодыДатчиков[КодыДатчиков.Количество() - 1].
//
Функция ПоискЗначенийВсехДатчиков(ДанныеДатчиков, ДанныеВиртуальныхДатчиков, КодыДатчиков, ВерсииФормата, ТекстОшибки = "", ДополнительныеПараметры = Неопределено) Экспорт
	
	// Инициализация переменных.
	КодыДатчиковКоличество = КодыДатчиков.Количество() - 1;
	Результат = Новый Массив();
	
	// Если список кодов датчиков отсутствует, то лишний раз не напрягаемся.
	Если -1 < КодыДатчиковКоличество Тогда	
		// Создаем массив результатов.
		Для СчетчикДатчиков = 0 По КодыДатчиковКоличество Цикл
		    Результат.Добавить(Новый Массив());
		КонецЦикла; 
		
		// Перебираем все значения датчиков.
		Для Счетчик = 0 По ДанныеДатчиков.Количество() - 1 Цикл
			СтруктураДанныеДатчиков = СтрокаДляДанныхДатчика(ДанныеДатчиков[Счетчик], ВерсииФормата[Счетчик], ТекстОшибки, ДополнительныеПараметры);
			Если НЕ ПустаяСтрока(ДанныеВиртуальныхДатчиков[Счетчик]) Тогда
				// Перебираем данные виртуальных датчиков.
				СтруктураДанныеДатчиковДоп = СтрокаДляДанныхДатчика(ДанныеВиртуальныхДатчиков[Счетчик], 1, ТекстОшибки, ДополнительныеПараметры);
				Для каждого ЭлементСтруктурыДоп Из СтруктураДанныеДатчиковДоп Цикл
					СтруктураДанныеДатчиков.Вставить(ЭлементСтруктурыДоп.Ключ, ЭлементСтруктурыДоп.Значение);
				КонецЦикла;			
			КонецЕсли;
			
			// Добавляем в результаты полученные данные по датчикам.
			Для СчетчикДатчиков = 0 По КодыДатчиковКоличество Цикл			
				// Получаем значение.
				Значение = СтруктураДанныеДатчиков.Получить(КодыДатчиков[СчетчикДатчиков]);
				
				// Проверяем значение, если пустое, то не добавляем.
				Если Не Значение = Неопределено Тогда
			    	Результат[СчетчикДатчиков].Добавить(Значение);
				КонецЕсли; 
			КонецЦикла; 		
		КонецЦикла; 		
	КонецЕсли;

	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Преобразовывает шестнадцатеричное в десятичное.
//
// Параметры:
//  Значение - Строка	 - Шестнадцатеричное значение.
// 
// Возвращаемое значение:
//  Число - Десятичное значение.
//
Функция HexData2Dec(Знач Значение="00")
	
	Нотация = 16;	 
	Значение = СокрЛП(Значение);
	
	Если Значение = "0" ИЛИ Значение = "00" Тогда 
		Возврат 0;
	ИначеЕсли Значение = "1" ИЛИ Значение = "01" Тогда 
		Возврат 1;	
	КонецЕсли;
	
	ТекДлина = СтрДлина(Значение);
	
	Если ТекДлина/2 <> Цел(ТекДлина/2) Тогда
		Значение = "0"+Значение;
		ТекДлина = СтрДлина(Значение);
	КонецЕсли;
	
	// Инверсия значения
	ИнвЗначение = "";
	ЧислоБайт = Цел(ТекДлина/2);
	Для Счетчик = 1 По ЧислоБайт Цикл
		ИнвЗначение = Сред(Значение,2*Счетчик-1,2) + ИнвЗначение;	
	КонецЦикла;
	
	Результат = 0;	 
	Для СчетчикХ=1 По ТекДлина Цикл		
		СчетчикМ = Pow(Нотация,ТекДлина-СчетчикХ);		
		Результат = Результат+(Найти("0123456789ABCDEF",Сред(ИнвЗначение,СчетчикХ,1))-1)*СчетчикМ;		
	КонецЦикла;
	
	Возврат Окр(Результат);
	
КонецФункции

Функция ДекодироватьКоординату(МассивСимволов)
	
	ДвоичноеЧисло ="";
	
	Счетчик = МассивСимволов.Количество()-1;
	Пока Счетчик >= 0 Цикл
		ДвоичноеЧисло = ДвоичноеЧисло + Прав("00000"+ItobОбщегоНазначенияКлиентСервер.ДесятичноеВДвоичное(МассивСимволов[Счетчик]),5);
		Счетчик = Счетчик-1;
	КонецЦикла;
	
	ЧислоОтрицательное = Прав(ДвоичноеЧисло,1) = "1";
	
	// Сдвиг вправо
	ДвоичноеЧисло = Лев(ДвоичноеЧисло,СтрДлина(ДвоичноеЧисло)-1);
	
	//// Учет отрицательных чисел
	Если ЧислоОтрицательное Тогда
		Рез = -1*(ItobОбщегоНазначенияКлиентСервер.ДвоичноеВДесятичное(ДвоичноеЧисло)+1);
		
	Иначе
		Рез = ItobОбщегоНазначенияКлиентСервер.ДвоичноеВДесятичное(ДвоичноеЧисло);
		
	КонецЕсли;
	
	Рез = Рез/100000;
	
	Возврат Рез;

КонецФункции // ДекодироватьКоординатуGoogle()

Функция ДекодироватьПолилинию(ТочкиПолилинии)
	
	ТекМассивДанных = Новый Массив;
	
	ТекМассивСимволов = Новый Массив;
	
	Для Счетчик=1 По СтрДлина(ТочкиПолилинии) Цикл
		ТекКодСимвола = КодСимвола(ТочкиПолилинии,Счетчик)-63;
		Если ТекКодСимвола >= 32 Тогда
			// Будет продолжение
			ТекМассивСимволов.Добавить(ТекКодСимвола-32);			
		Иначе
			// Это край
			ТекМассивСимволов.Добавить(ТекКодСимвола);
			
			Координата = ДекодироватьКоординату(ТекМассивСимволов);
			ТекМассивДанных.Добавить(Координата);
			
			ТекМассивСимволов.Очистить();		
		КонецЕсли;		
		
	КонецЦикла;
	
	Для Счетчик = 1 По ТекМассивДанных.Количество()/2-1 Цикл
		Счетчик2 = 2*Счетчик;
		ТекМассивДанных[Счетчик2] = ТекМассивДанных[Счетчик2-2]+ТекМассивДанных[Счетчик2];
		ТекМассивДанных[Счетчик2+1] = ТекМассивДанных[Счетчик2-1]+ТекМассивДанных[Счетчик2+1];			
	КонецЦикла;
	
	Результат = Новый Массив();
	Для Счетчик = 0 По ТекМассивДанных.Количество() / 2 - 1 Цикл
		Счетчик2 = Счетчик * 2;
		Результат.Добавить(Новый Структура("Широта,Долгота", ТекМассивДанных[Счетчик2], ТекМассивДанных[Счетчик2 + 1]));
	КонецЦикла;
	
	Возврат Результат;
		
КонецФункции

#КонецОбласти