
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	ДвоичныеДанныеФайла = СсылкаНаДвоичныеДанныеФайла(Объект.Факсимиле, Новый УникальныйИдентификатор);
	ФаксимилеПодписи    = ДвоичныеДанныеФайла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если ТипЗнч(Параметр) = Тип("Структура") 
			И Параметр.Свойство("ВладелецФайла")
			И ТипЗнч(Параметр.ВладелецФайла) = Тип("СправочникСсылка.уатПодписи") Тогда
			Модифицированность = Истина;
			ИзображениеДобавленныеФаксимиле(Источник);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФаксимилеПодписиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НЕ ЗначениеЗаполнено(ФаксимилеПодписи) Тогда
		
		ДобавитьИзображениеНаКлиенте();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаСервере
Процедура ИзображениеДобавленныеФаксимиле(Источник)
	
	Если ТипЗнч(Источник) = Тип("Массив") Тогда
		
		СсылкаНаПрисоединенныйФайл = Источник[0];
		
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.уатПодписиПрисоединенныеФайлы") Тогда
		
		СсылкаНаПрисоединенныйФайл = Источник;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	ДвоичныеДанныеФайла	= СсылкаНаДвоичныеДанныеФайла(СсылкаНаПрисоединенныйФайл, УникальныйИдентификатор);
	
	ФаксимилеПодписи = ДвоичныеДанныеФайла;
	Объект.Факсимиле = СсылкаНаПрисоединенныйФайл;
	
	
КонецПроцедуры

&НаКлиенте
Процедура НапечататьПомощникСозданияФаксимилеПодписи(Команда)
	
	СтруктураДополнительныхПараметров = Новый Структура("ЗаголовокФормы", Нстр("ru ='Инструкция ""Как создать факсимиле подписи""'"));
	
	ПараметрыКомандыПечати = Новый Массив;
	ПараметрыКомандыПечати.Добавить(Объект.Ссылка);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.уатПодписи", "НапечататьПомощникСозданияФаксимилеПодписи", ПараметрыКомандыПечати, ЭтотОбъект, СтруктураДополнительныхПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФаксимилеПодписи(Команда)
	
	Если ПустаяСтрока(ФаксимилеПодписи) Тогда
		
		ДобавитьИзображениеНаКлиенте();
		
	Иначе
		
		ЗаменитьФаксимилеПодписиНаКлиенте(ФаксимилеПодписи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрПечатнойФормыСчетНаОплату(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
		ИЛИ Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru='Для предварительного просмотра печатной формы ""Счет на оплату"" необходимо записать объект. Записать?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ПредварительныйПросмотрПечатнойФормыСчетНаОплатуЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;

	СтруктураДополнительныхПараметров = Новый Структура("Подпись", Объект.Ссылка);
	
	ПараметрыПечати = Новый Структура("ЗаголовокФормы, ДополнительныеПараметры", "Предварительный просмотр печатной формы Счет на оплату.", СтруктураДополнительныхПараметров);
	
	ПараметрыКомандыПечати = Новый  Массив;
	ПараметрыКомандыПечати.Добавить(ПредопределенноеЗначение("Документ.уатСчетНаОплатуПокупателю.ПустаяСсылка"));
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.уатСчетНаОплатуПокупателю", "ПредварительныйПросмотрПечатнойФормыСчетНаОплату", ПараметрыКомандыПечати, ЭтотОбъект, ПараметрыПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФаксимилеПодписи(Команда)
	Объект.Факсимиле = Неопределено;
	ФаксимилеПодписи = "";
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзПрисоединенныхФайлов(Команда)
	ВыбратьКартинкуИзПрисоединенныхФайлов();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимиле(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ДобавитьИзображениеФаксимилеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДобавитьИзображениеФаксимилеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимилеФрагмент()
	
	Перем ИдентификаторФайла;
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВладелецФайла", Объект.Ссылка);
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
		
		ДополнительныеПараметры = Новый Структура("ИмяЭлементаСКартинкой", "Факсимиле");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКартинкуИзПрисоединенныхФайловЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, Элементы.ФаксимилеПодписи, , , , ОписаниеОповещения);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СсылкаНаДвоичныеДанныеФайла(ПрисоединенныйФайл, ИдентификаторФормы)
	
	УстановитьПривилегированныйРежим(Истина);
	Попытка
		Возврат РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции 

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ДобавитьИзображениеНаКлиентеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДобавитьИзображениеНаКлиентеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	
	ДобавитьИзображениеНаКлиентеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеФрагмент()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ИдентификаторФайла = Новый УникальныйИдентификатор;
		
		Фильтр = НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf"
		+ "|Все файлы(*.*)|*.*"
		+ "|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle"
		+ "|Формат GIF(*.gif*)|*.gif"
		+ "|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg"
		+ "|Формат PNG(*.png*)|*.png"
		+ "|Формат TIFF(*.tif)|*.tif"
		+ "|Формат icon(*.ico)|*.ico"
		+ "|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
		
		РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла,Фильтр);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаменитьФаксимилеПодписиНаКлиенте(СсылкаНаФаксимиле)
	
	ДанныеФайла = ПолучитьДанныеФайла(Объект.Факсимиле, УникальныйИдентификатор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьКартинкуПослеЗамены", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ОбновитьИзФайлаНаДискеСОповещением(ОписаниеОповещения, ДанныеФайла, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьКартинкуПослеЗамены(ИнформацияОФайле, СтрокаОписанияРедактируемогоИзображения) Экспорт
	
	Если ИнформацияОФайле = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ИзображениеСсылка = Объект.Факсимиле;
	ИзменитьИзображениеЗавершениеНаСервере(ИнформацияОФайле, ИзображениеСсылка);
	
	АдресФаксимиле   = ИнформацияОФайле.АдресФайлаВоВременномХранилище;
	ФаксимилеПодписи = ИнформацияОФайле.АдресФайлаВоВременномХранилище;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИзображениеЗавершениеНаСервере(ИнформацияОФайле, ИзображениеСсылка)
	
	РаботаСФайлами.ОбновитьФайл(ИзображениеСсылка, ИнформацияОФайле);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(ФайлКартинки, УникальныйИдентификатор)
	
	Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайловЗавершение(ВыбраннаяКартинка, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбраннаяКартинка) Тогда
		
		УстановитьКартинкуВЭлементе(ВыбраннаяКартинка, ДополнительныеПараметры.ИмяЭлементаСКартинкой);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКартинкуВЭлементе(ФайлКартинки, ИмяЭлементаСКартинкой)
	
	Модифицированность = Истина;
	
	ИмяАдресаКартинки = ФаксимилеПодписи;
	Объект.Факсимиле  = ФайлКартинки;
	
	Если ЗначениеЗаполнено(ФайлКартинки) Тогда
		ФаксимилеПодписи = ПолучитьКартинку(ФайлКартинки, УникальныйИдентификатор);
	Иначе
		ФаксимилеПодписи = "";
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКартинку(ФайлКартинки, УникальныйИдентификатор)
	
	ДанныеКартинки = РаботаСФайлами.ДанныеФайла(ФайлКартинки, УникальныйИдентификатор);
	Возврат ДанныеКартинки.СсылкаНаДвоичныеДанныеФайла;
	
КонецФункции

&НаКлиенте
Процедура ПредварительныйПросмотрПечатнойФормыСчетНаОплатуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Записать();
	
	
	СтруктураДополнительныхПараметров = Новый Структура("Подпись", Объект.Ссылка);
	
	ПараметрыПечати = Новый Структура("ЗаголовокФормы, ДополнительныеПараметры", "Предварительный просмотр печатной формы Счет на оплату.", СтруктураДополнительныхПараметров);
	
	ПараметрыКомандыПечати = Новый  Массив;
	ПараметрыКомандыПечати.Добавить(ПредопределенноеЗначение("Документ.уатСчетНаОплатуПокупателю.ПустаяСсылка"));
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.уатСчетНаОплатуПокупателю", "ПредварительныйПросмотрПечатнойФормыСчетНаОплату", ПараметрыКомандыПечати, ЭтотОбъект, ПараметрыПечати);
	
	
КонецПроцедуры

#КонецОбласти