#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// Позволяет определить список заблокированных реквизитов.
// 
// Возвращаемое значение:
//  Массив - из Строка - строки в формате "ИмяРеквизита[;ИмяЭлементаФормы,...]",
//  где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы -
//  имя элемента формы, связанного с реквизитом. Например: "Объект.Автор", "ПолеАвтор".
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив();
	
	БлокируемыеРеквизиты.Добавить("ВидМоделиТС");
	БлокируемыеРеквизиты.Добавить("НаличиеТопливногоБака");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#КонецЕсли