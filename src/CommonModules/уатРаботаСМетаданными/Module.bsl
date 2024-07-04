////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для работы с объектами метаданных
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Позволяет определить есть ли среди реквизитов шапки документа
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеДокумента - объект описания метаданных документа, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьРеквизитДокумента(ИмяРеквизита, МетаданныеДокумента) Экспорт
	
	Если МетаданныеДокумента.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли; 
	
КонецФункции // уатЕстьРеквизитДокумента()

// Позволяет определить есть ли табличная часть документа с переданным именем.
//
// Параметры: 
//  ИмяТабЧасти - строковое имя искомой табличной части,
//  МетаданныеДокумента - объект описания метаданных документа, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция ЕстьТабЧастьДокумента(ИмяТабЧасти, НаименованиеДокумента) Экспорт
	Если Метаданные.Документы[НаименованиеДокумента].ТабличныеЧасти.Найти(ИмяТабЧасти) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли; 
КонецФункции // ЕстьТабЧастьДокумента()

// Позволяет определить есть ли среди реквизитов табличной части документа
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеДокумента - объект описания метаданных документа, среди реквизитов которого производится поиск.
//  ИмяТабЧасти  - строковое имя табличной части документа, среди реквизитов которого производится поиск
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция ЕстьРеквизитТабЧастиДокумента(ИмяРеквизита, МетаданныеДокумента, ИмяТабЧасти) Экспорт
	
	ТабЧасть = МетаданныеДокумента.ТабличныеЧасти.Найти(ИмяТабЧасти);
	Если ТабЧасть = Неопределено Тогда // Нет такой таб. части в документе
		Возврат Ложь;
	Иначе
		Если ТабЧасть.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции // ЕстьРеквизитТабЧастиДокумента()

// Позволяет определить есть ли такой регистр сведения
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеСправочника - объект описания метаданных справочника, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьДокумент(НаименованиеДокумента) Экспорт
	
	Если Метаданные.Документы.Найти(СокрЛП(НаименованиеДокумента)) = Неопределено Тогда
		Возврат Ложь;
	Иначе	
		Возврат Истина;
	КонецЕсли;	
	
КонецФункции

// Позволяет определить есть ли такой регистр сведения
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеСправочника - объект описания метаданных справочника, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьКонстанта(НаименованиеКонстанты) Экспорт
	
	Если Метаданные.Константы.Найти(СокрЛП(НаименованиеКонстанты)) = Неопределено Тогда
		Результат = Ложь;
	Иначе	
		Результат = Истина;
	КонецЕсли;;	
	
	Возврат Результат;
	
КонецФункции // уатЕстьРегистрСведений()

// Позволяет определить есть ли такой справочник
//
// Параметры: 
//  НаименованиеСправочника - строковое имя проверяемого справочника 
//
// Возвращаемое значение:
//  Истина - искомый справочник присутствует в системе
//
Функция ЕстьСправочник(НаименованиеСправочника) Экспорт
	Если Метаданные.Справочники.Найти(СокрЛП(НаименованиеСправочника)) = Неопределено Тогда
		Возврат Ложь;
	Иначе	
		Возврат Истина;
	КонецЕсли;	
КонецФункции

// Позволяет определить есть ли такой регистр сведения
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеСправочника - объект описания метаданных справочника, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьРегистрСведений(НаименованиеРегистраСведений) Экспорт
	
	Если Метаданные.НайтиПоПолномуИмени("РегистрСведений."+СокрЛП(НаименованиеРегистраСведений)) = Неопределено Тогда
		Результат = Ложь;
	Иначе	
		Результат = Истина;
	КонецЕсли;;	
	
	Возврат Результат;
	
КонецФункции // уатЕстьРегистрСведений()

// Позволяет определить есть ли такой регистр сведения
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеСправочника - объект описания метаданных справочника, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьРегистрНакоплений(НаименованиеРегистраНакоплений) Экспорт
	
	Если Метаданные.НайтиПоПолномуИмени("РегистрНакопления."+СокрЛП(НаименованиеРегистраНакоплений)) = Неопределено Тогда
		Результат = Ложь;
	Иначе	
		Результат = Истина;
	КонецЕсли;;	
	
	Возврат Результат;
	
КонецФункции // уатЕстьРегистрНакоплений()

// Позволяет определить есть ли такой регистр сведения
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеСправочника - объект описания метаданных справочника, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьРегистрБухгалтерии(НаименованиеРегистраБухгалтерии) Экспорт
	
	Если Метаданные.НайтиПоПолномуИмени("РегистрБухгалтерии."+СокрЛП(НаименованиеРегистраБухгалтерии)) = Неопределено Тогда
		Результат = Ложь;
	Иначе	
		Результат = Истина;
	КонецЕсли;;	
	
	Возврат Результат;
	
КонецФункции // уатЕстьРегистрНакоплений()

// Позволяет определить есть ли среди реквизитов шапки справочника
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеСправочника - объект описания метаданных справочника, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьРеквизитСправочника(ИмяРеквизита, СправочникОбъект) Экспорт
	
	Попытка
		МетаданныеСправочника = СправочникОбъект.Метаданные();
		Если МетаданныеСправочника.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли; 
	Исключение
		Возврат Ложь;
	КонецПопытки;	
	
КонецФункции // ЕстьРеквизитСправочника()

// Позволяет определить есть ли среди реквизитов шапки справочника
// реквизит с переданным именем.
//
// Параметры: 
//  ИмяРеквизита - строковое имя искомого реквизита, 
//  МетаданныеСправочника - объект описания метаданных справочника, среди реквизитов которого производится поиск.
//
// Возвращаемое значение:
//  Истина - нашли реквизит с таким именем, Ложь - не нашли.
//
Функция уатЕстьИзмерениеРегистра(ИмяРеквизита, Регистр) Экспорт
	
	Попытка
		Если Регистр.Метаданные().Измерения.Найти(ИмяРеквизита) = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли; 
	Исключение
		Возврат Ложь;
	КонецПопытки;	
	
КонецФункции // 

// Возвращает список реквизитов шапки документа
//
// Возвращаемое значение:
//  Массив - список реквизитов шапки объекта
//
Функция РеквизитыШапкиДокумента(ИмяДокумента) Экспорт
	мсвРеквизиты = Новый Массив;
	мсвРеквизиты.Добавить("Ссылка");
	Для Каждого ТекРеквизит Из Метаданные.Документы[ИмяДокумента].СтандартныеРеквизиты Цикл
		мсвРеквизиты.Добавить(ТекРеквизит.Имя);
	КонецЦикла;
	Для Каждого ТекРеквизит Из Метаданные.Документы[ИмяДокумента].Реквизиты Цикл
		мсвРеквизиты.Добавить(ТекРеквизит.Имя);
	КонецЦикла;
	Возврат мсвРеквизиты;
КонецФункции

#КонецОбласти
