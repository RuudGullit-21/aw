////////////////////////////////////////////////////////////////////////////////
// Модуль является оберткой для библиотеки CsmHandler.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает версию библиотеки CsmHandler.
//
// Параметры:
//  ТекстОшибки	 - Строка	 - Текст ошибки.
// 
// Возвращаемое значение:
//  Строка - Версия библиотеки CsmHandler.
//
Функция Версия(ТекстОшибки = "") Экспорт
	
	Библиотека = ПолучитьБиблиотеку(ТекстОшибки);
	
	Результат = Неопределено;
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда	
		Попытка
			Результат = Библиотека.Версия();		
		Исключение	
			ТекстОшибки = "Ошибка на стороне внешней компоненты. " + ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции
 
// Рассчитывает расстояние между точками по географическим координатам.
//
// Параметры:
//  Широта1		 - Число - Широта первой дочки.
//  Широта2		 - Число - Широта второй дочки.
//  Долгота1	 - Число - Долгота первой дочки.
//  Долгота2	 - Число - Долгота второй дочки.
//  ТекстОшибки	 - Строка	 - Текст ошибки.
// 
// Возвращаемое значение:
//  Число - Расстояние между точками.
//
Функция Расстояние(Знач Широта1, Знач Широта2, Знач Долгота1, Знач Долгота2, ТекстОшибки = "") Экспорт
	
	Библиотека = ПолучитьБиблиотеку(ТекстОшибки);
	
	Результат = Неопределено;
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда	
		Попытка
			Результат = Библиотека.Расстояние(Широта1, Широта2, Долгота1, Долгота2);		
		Исключение	
			ТекстОшибки = "Ошибка на стороне внешней компоненты. " + ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции
 
// Преобразует закодированные данные в коды датчиков и их значения.
//
// Параметры:
//  ДанныеДатчиков	 - Строка	 - Закодированные данные датчиков.
//  ВерсияФормата	 - Число	 - Версия формата данных.
//  ТекстОшибки		 - Строка	 - Текст ошибки.
// 
// Возвращаемое значение:
//  Строка - JSON массив из двух элементов, массив кодов датчиков и массив значений датчиков.
//
Функция СтрокаДляДанныхДатчика(Знач ДанныеДатчиков, Знач ВерсияФормата, ТекстОшибки = "") Экспорт
		
	Библиотека = ПолучитьБиблиотеку(ТекстОшибки);
	
	Результат = Неопределено;
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда	
		Попытка
			Результат = Библиотека.СтрокаДляДанныхДатчика(ДанныеДатчиков, ВерсияФормата);		
		Исключение	
			ТекстОшибки = "Ошибка на стороне внешней компоненты. " + ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции
 
// Рассчитывает расстояния между точками.
//
// Параметры:
//  Координаты	 - Строка	 - Массив координат в JSON.
//  ТекстОшибки	 - Строка	 - Текст ошибки.
// 
// Возвращаемое значение:
//  Строка - Массив расстояний в JSON.
//
Функция МассивРасстояний(Знач Координаты, ТекстОшибки = "") Экспорт
	
	Библиотека = ПолучитьБиблиотеку(ТекстОшибки);
	
	Результат = Неопределено;
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда	
		Попытка
			Результат = Библиотека.МассивРасстояний(Координаты);		
		Исключение	
			ТекстОшибки = "Ошибка на стороне внешней компоненты. " + ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции
 
// Преобразует закодированную полилинию из формата ломанной линии предоставленного гугл сервисом.
//
// Параметры:
//  ЗакодированнаяПолилиния	 - Строка	 - Закодированная полилиния.
//  ТекстОшибки				 - Строка	 - Текст ошибки.
// 
// Возвращаемое значение:
//  Строка - JSON массив их двух элементов, массив с широтами и массив с долготами.
//
Функция РаскодированиеЛинии(Знач ЗакодированнаяПолилиния, ТекстОшибки = "") Экспорт
	
	Библиотека = ПолучитьБиблиотеку(ТекстОшибки);
	
	Результат = Неопределено;
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда	
		Попытка
			Результат = Библиотека.РаскодированиеЛинии(ЗакодированнаяПолилиния);		
		Исключение	
			ТекстОшибки = "Ошибка на стороне внешней компоненты. " + ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли;
	
	
	Возврат Результат;

КонецФункции
  
// Ищет значения датчиков в закодированных данных датчиков (включая виртуальные).
//
// Параметры:
//  ДанныеДатчиков				 - Строка	 - JSON массив из строк закодированных данных датчиков.
//  ДанныеВиртуальныхДатчиков	 - Строка	 - JSON массив из строк закодированных данных датчиков, 
//		элементов в массиве столько же сколько и в ДанныеДатчиков.
//	
//  КодыДатчиков				 - Строка	 - JSON массив из кодов датчиков, которые нужно получить.
//  ВерсииФормата				 - Строка	 - JSON массив из версий форматов, 
//		элементов в массиве столько же сколько и в ДанныеДатчиков.
//
//  ТекстОшибки					 - Строка	 - Текст ошибки.
// 
// Возвращаемое значение:
//  Строка - JSON массив массивов,
//  	0 элемент массива - массив значений для кода датчика КодыДатчиков[0],
//  	и т.п. до КодыДатчиков[КодыДатчиков.Количество() - 1].
//
Функция ПоискЗначенийВсехДатчиков(Знач ДанныеДатчиков, Знач ДанныеВиртуальныхДатчиков, Знач КодыДатчиков, Знач ВерсииФормата, ТекстОшибки = "") Экспорт
	
	Библиотека = ПолучитьБиблиотеку(ТекстОшибки);
	
	Результат = Неопределено;
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда	
		Попытка
			Результат = Библиотека.ПоискЗначенийВсехДатчиков(ДанныеДатчиков, ДанныеВиртуальныхДатчиков, КодыДатчиков, ВерсииФормата);		
		Исключение	
			ТекстОшибки = "Ошибка на стороне внешней компоненты. " + ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции

// Функция - Разархивировать GZIP
//
// Параметры:
//  СтрокаДвоичныхДанных - 	Строка - Двоичные данные для разархивирования
//  ТекстОшибки			 - Строка - Строка с текстом ошибки
// 
// Возвращаемое значение:
//   - Разархивированное значение
//
Функция РазархивироватьGZIP(Знач СтрокаДвоичныхДанных, ТекстОшибки = "") Экспорт
	
	Библиотека = ПолучитьБиблиотеку(ТекстОшибки);
	
	Результат = Неопределено;
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда	
		Попытка
			Результат = Библиотека.GZIPDecode(СтрокаДвоичныхДанных);		
		Исключение	
			ТекстОшибки = "Ошибка на стороне внешней компоненты. " + ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьБиблиотеку(ТекстОшибки = "")
	
	Возврат ItobCsmHandlerПовтИсп.ПолучитьБиблиотеку(ТекстОшибки);
	
КонецФункции
 
#КонецОбласти